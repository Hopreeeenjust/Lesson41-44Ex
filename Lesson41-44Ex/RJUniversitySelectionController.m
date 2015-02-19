//
//  RJUniversitySelectionController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 17.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJUniversitySelectionController.h"
#import "RJUniversity.h"

@interface RJUniversitySelectionController ()

@end

@implementation RJUniversitySelectionController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    [[UITableViewCell appearance] setTintColor:purple];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    if (self.lastIndexPath) {
        self.university = [self.universities objectAtIndex:self.lastIndexPath.row];
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
    [self.delegate didChooseUniversity:self.university atIndexPath:self.lastIndexPath];
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
    self.university = [self.universities objectAtIndex:indexPath.row];
    self.lastIndexPath = indexPath;
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
