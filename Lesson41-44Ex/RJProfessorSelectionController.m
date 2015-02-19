//
//  RJProfessorSelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJProfessorSelectionController.h"
#import "RJProfessor.h"
#import "RJSelectionListCell.h"

@interface RJProfessorSelectionController ()

@end

@implementation RJProfessorSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    [[UITableViewCell appearance] setTintColor:purple];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    if (self.lastIndexPath) {
        self.professor = [self.professors objectAtIndex:self.lastIndexPath.row];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.lastIndexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    [self.delegate didChooseProfessor:self.professor atIndexPath:self.lastIndexPath];
    [self.navigationController popToViewController:self.previousController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndexPath) {
        [[tableView cellForRowAtIndexPath:self.lastIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.professor = [self.professors objectAtIndex:indexPath.row];
    self.lastIndexPath = indexPath;
    [tableView reloadData];
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.professors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Professor";
    RJSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJSelectionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RJProfessor *professor = [self.professors objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", professor.firstName, professor.lastName];
    if (indexPath != self.lastIndexPath) {
        cell.courseCountLabel.text = [NSString stringWithFormat:@"Teaches %ld courses", [professor.courses count]];
    } else {
        cell.courseCountLabel.text = [NSString stringWithFormat:@"Teaches %ld courses", [professor.courses count] + 1];
    }
    return cell;
}

@end
