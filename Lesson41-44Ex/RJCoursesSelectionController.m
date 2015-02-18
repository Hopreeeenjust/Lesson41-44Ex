//
//  RJCoursesSelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 17.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCoursesSelectionController.h"
#import "RJSelectionListCell.h"
#import "RJCourse.h"
#import "RJProfessor.h"

@interface RJCoursesSelectionController ()

@end

@implementation RJCoursesSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    if (!self.indexPathForChosenCourses) {
        self.IndexPathForChosenCourses = [NSArray new];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.indexPathForChosenCourses) {
        for (NSIndexPath *indexPath in self.indexPathForChosenCourses) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    self.indexPathForChosenCourses = [NSArray new];
    for (RJSelectionListCell *cell in self.tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.delegate didChooseCoursesAtIndexPath:self.indexPathForChosenCourses];
    [self.navigationController popToViewController:self.previousController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CourseToChoose";
    RJSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJSelectionListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    RJCourse *course = [self.courses objectAtIndex:indexPath.row];
    cell.label.text = course.name;
    cell.detailLabel.text = [NSString stringWithFormat:@"Attendance: %ld", [course.students count]];
    cell.subTitle.text = [NSString stringWithFormat:@"Professor %@ %@", course.professor.firstName, course.professor.lastName];
    return cell;
}

@end