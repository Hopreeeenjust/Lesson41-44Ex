//
//  RJProfessorsSelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJProfessorsSelectionController.h"
#import "RJProfessor.h"

@interface RJProfessorsSelectionController ()

@end

@implementation RJProfessorsSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    self.navigationController.title = @"Choose professor";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    barButton.tintColor = purple;
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = purple;
    [[UITableViewCell appearance] setTintColor:purple];
    if (!self.indexPathForChosenProfessors) {
        self.indexPathForChosenProfessors = [NSArray new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    self.indexPathForChosenProfessors = [self.indexPathForChosenProfessors sortedArrayUsingDescriptors:@[descriptor]];
    [self.delegate didChooseProfessorsAtIndexPath:self.indexPathForChosenProfessors];
    [self.navigationController popToViewController:self.previousController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[self mutableArrayValueForKey:@"indexPathForChosenProfessors"] removeObject:indexPath];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self mutableArrayValueForKey:@"indexPathForChosenProfessors"] addObject:indexPath];
    }
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.professors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Professor";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RJProfessor *professor = [self.professors objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", professor.firstName, professor.lastName];
    if ([professor.courses count] == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Lecturer on %ld course", [professor.courses count]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Lecturer on %ld courses", [professor.courses count]];
    }
    cell.detailTextLabel.textColor = [UIColor blueColor];
    if ([self.indexPathForChosenProfessors containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

@end
