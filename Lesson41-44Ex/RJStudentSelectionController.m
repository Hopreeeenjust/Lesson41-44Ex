//
//  RJStudentSelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJStudentSelectionController.h"
#import "RJSelectionListCell.h"
#import "RJStudent.h"

@interface RJStudentSelectionController ()

@end

@implementation RJStudentSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    [[UITableViewCell appearance] setTintColor:purple];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    if (!self.indexPathForChosenStudents) {
        self.indexPathForChosenStudents = [NSArray new];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.indexPathForChosenStudents) {
        for (NSIndexPath *indexPath in self.indexPathForChosenStudents) {
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
    self.indexPathForChosenStudents = [NSArray new];
    for (RJSelectionListCell *cell in self.tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [[self mutableArrayValueForKey:@"indexPathForChosenStudents"] addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.delegate didChooseStudentsAtIndexPath:self.indexPathForChosenStudents];
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
    return [self.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"StudentToChoose";
    RJStudent *student = [self.students objectAtIndex:indexPath.row];
    RJSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJSelectionListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.label.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    if ([student.courses count] == 1) {
        cell.subTitle.text = [NSString stringWithFormat:@"Attend %ld course", [student.courses count]];
    } else {
        cell.subTitle.text = [NSString stringWithFormat:@"Attend %ld courses", [student.courses count]];
    }
    cell.detailLabel.text = [NSString stringWithFormat:@"Score: %.2f", [student.score floatValue]];
    return cell;
}

@end
