//
//  RJUniversitiesSelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 18.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJUniversitiesSelectionController.h"
#import "RJUniversity.h"

@interface RJUniversitiesSelectionController ()

@end

@implementation RJUniversitiesSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    self.navigationController.title = @"Choose university";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    barButton.tintColor = purple;
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = purple;
    [[UITableViewCell appearance] setTintColor:purple];
    if (!self.indexPathForChosenUniversities) {
        self.indexPathForChosenUniversities = [NSArray new];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.indexPathForChosenUniversities) {
        for (NSIndexPath *indexPath in self.indexPathForChosenUniversities) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    self.indexPathForChosenUniversities = [NSArray new];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [[self mutableArrayValueForKey:@"indexPathForChosenUniversities"] addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.delegate didChooseUniversitiesAtIndexPath:self.indexPathForChosenUniversities];
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
    return [self.universities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"University";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RJUniversity *university = [self.universities objectAtIndex:indexPath.row];
    cell.textLabel.text = university.name;
    return cell;
}

@end
