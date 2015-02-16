//
//  RJStudentProfileController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJStudentProfileController.h"
#import "RJStudent.h"
#import "RJDataManager.h"
#import "RJTableViewCell.h"

@interface RJStudentProfileController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) RJTableViewCell *nameCell;
@property (strong, nonatomic) RJTableViewCell *surnameCell;
@property (strong, nonatomic) RJTableViewCell *scoreCell;
@property (strong, nonatomic) RJTableViewCell *universityCell;

@end

@implementation RJStudentProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSManagedObjectContext

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[RJDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Actions

- (IBAction)actionDoneButtonPressed:(id)sender {
    RJStudent *student = [NSEntityDescription insertNewObjectForEntityForName:@"RJStudent" inManagedObjectContext:self.managedObjectContext];
    student.firstName = self.nameCell.firstNameField.text;
    student.lastName = self.surnameCell.lastNameField.text;
    student.score = [NSNumber numberWithFloat:[self.scoreCell.intScoreField.text integerValue] + [self.scoreCell.decimalScoreField.text floatValue] / 100];
//    student.university = 
    [[RJDataManager sharedManager] saveContext];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return [self.student.courses count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *firstNameField = @"Name";
    static NSString *lastNameField = @"Surname";
    static NSString *scoreField = @"Score";
    static NSString *universityField = @"University";
    static NSString *newCourseField = @"NewCourse";
    static NSString *coursesField = @"Course";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstNameField];
            if (!cell) {
                cell = [[RJTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:firstNameField];
            }
            self.nameCell = cell;
            return cell;
        } else if (indexPath.row == 1) {
            RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastNameField];
            if (!cell) {
                cell = [[RJTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lastNameField];
            }
            self.surnameCell = cell;
            return cell;
        } else if (indexPath.row == 2) {
            RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreField];
            if (!cell) {
                cell = [[RJTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scoreField];
            }
            self.scoreCell = cell;
            return cell;
        } else if (indexPath.row == 3) {
            RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:universityField];
            if (!cell) {
                cell = [[RJTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:universityField];
            }
            self.universityCell = cell;
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCourseField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newCourseField];
            }
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:coursesField];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:coursesField];
        }
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Student personal data";
    } else {
        return @"Student's courses";
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(20, 4, CGRectGetWidth(tableView.bounds), 20);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.05f];
    [headerView addSubview:label];
    return headerView;
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == self.scoreCell.decimalScoreField) {
//        return [textField resignFirstResponder];
//    } else {
//        return [textField resignFirstResponder];
//    }
    return YES;
}

@end
