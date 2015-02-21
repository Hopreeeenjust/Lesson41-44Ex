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
#import "RJStudentProfileController.h"
#import "RJProfessorProfileController.h"
#import "RJUniversity.h"

@interface RJCoursesSelectionController ()

@end

@implementation RJCoursesSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    [[UITableViewCell appearance] setTintColor:purple];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    if (!self.indexPathForChosenCourses) {
        self.IndexPathForChosenCourses = [NSArray new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    self.indexPathForChosenCourses = [self.indexPathForChosenCourses sortedArrayUsingDescriptors:@[descriptor]];
    [self.delegate didChooseCoursesAtIndexPath:self.indexPathForChosenCourses];
    [self.navigationController popToViewController:self.previousController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] removeObject:indexPath];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] addObject:indexPath];
    }
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CourseToChoose";
    static NSString *identifierMulti = @"CourseToChooseMulti";
    RJCourse *course = [self.courses objectAtIndex:indexPath.row];
    if ([self.previousController isKindOfClass:[RJStudentProfileController class]]) {
        RJSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RJSelectionListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.label.text = course.name;
        if (course.professor) {
            cell.detailLabel.text = [NSString stringWithFormat:@"Attendance: %ld", [course.students count]];
            cell.subTitle.text = [NSString stringWithFormat:@"Professor %@ %@", course.professor.firstName, course.professor.lastName];
        } else {
            cell.detailLabel.text = [NSString stringWithFormat:@"Applications: %ld", [course.students count]];
            cell.subTitle.text = @"No professor for this course yet";
        }
        if ([self.indexPathForChosenCourses containsObject:indexPath]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return cell;
    } else if ([self.previousController isKindOfClass:[RJProfessorProfileController class]]) {
        RJSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMulti];
        if (!cell) {
            cell = [[RJSelectionListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierMulti];
        }
        cell.label.text = course.name;
        if (course.professor != nil) {
            cell.universityLabel.text = [NSString stringWithFormat:@"Attendance: %ld", [course.students count]];
        } else {
            cell.universityLabel.text = [NSString stringWithFormat:@"Applications: %ld", [course.students count]];
        }
        cell.subTitle.text = course.university.name;
        if ([self.indexPathForChosenCourses containsObject:indexPath]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return cell;
    }
    return nil;
}

@end
