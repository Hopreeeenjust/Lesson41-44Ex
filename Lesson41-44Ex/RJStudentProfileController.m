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
#import "RJStudentProfileCell.h"
#import "RJUniversitySelectionController.h"
#import "RJCoursesSelectionController.h"
#import "RJCourse.h"
#import "RJUniversity.h"

typedef NS_ENUM(NSInteger, RJFieldType) {
    RJFieldTypeNameField = 0,
    RJFieldTypeSurnameField,
    RJFieldTypeIntScoreField,
    RJFieldTypeDecimalScoreField,
    RJFieldTypeUniversityField,
};

@interface RJStudentProfileController () <UITableViewDataSource, UITableViewDelegate, RJUniversityDelegate, RJCourseDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) RJStudentProfileCell *nameCell;
@property (strong, nonatomic) RJStudentProfileCell *surnameCell;
@property (strong, nonatomic) RJStudentProfileCell *scoreCell;
@property (strong, nonatomic) RJStudentProfileCell *universityCell;

@property (strong, nonatomic) RJUniversity *chosenUniversity;
@property (strong, nonatomic) NSIndexPath *chosenIndexPath;
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) NSArray *courses;      //all courses for selected university
@property (strong, nonatomic) NSArray *indexPathForChosenCourses;
@property (strong, nonatomic) NSArray *chosenCourses;    //chosen courses by student
@end

@implementation RJStudentProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.universities = [NSArray new];
    self.chosenCourses = [NSArray new];
    self.indexPathForChosenCourses = [NSArray new];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];

    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.universities = [self getAllObjectsWithEntityName:@"RJUniversity" predicate:nil andSortDescriptors:@[nameDescriptor]];
    if (!self.newStudent) {
        self.chosenUniversity = self.university;
        NSPredicate *coursesPredicate = [NSPredicate predicateWithFormat:@"university == %@", self.chosenUniversity];
        self.courses = [self getAllObjectsWithEntityName:@"RJCourse" predicate:coursesPredicate andSortDescriptors:@[nameDescriptor]];
        self.chosenCourses = [[self.coursesSet allObjects] sortedArrayUsingDescriptors:@[nameDescriptor]];
        for (RJCourse *course in self.chosenCourses) {
            NSInteger rowOfChosenCourse = [self.courses indexOfObject:course];
            NSIndexPath *chosenCoursePath = [NSIndexPath indexPathForRow:rowOfChosenCourse inSection:0];
            [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] addObject:chosenCoursePath];
        }
        NSInteger row = [self.universities indexOfObject:self.university];
        self.chosenIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if (self.newStudent) {
        RJStudent *student = [NSEntityDescription insertNewObjectForEntityForName:@"RJStudent" inManagedObjectContext:self.managedObjectContext];
        student.firstName = self.nameCell.firstNameField.text;
        student.lastName = self.surnameCell.lastNameField.text;
        student.score = [NSNumber numberWithFloat:[self.scoreCell.intScoreField.text integerValue] + [self.scoreCell.decimalScoreField.text floatValue] / 100];
        student.university = [self.universities objectAtIndex:self.chosenIndexPath.row];
        student.courses = [NSSet setWithArray:self.chosenCourses];
        [[RJDataManager sharedManager] saveContext];
    } else {
        self.student.firstName = self.nameCell.firstNameField.text;
        self.student.lastName = self.surnameCell.lastNameField.text;
        self.student.score = [NSNumber numberWithFloat:[self.scoreCell.intScoreField.text integerValue] + [self.scoreCell.decimalScoreField.text floatValue] / 100];
        self.student.university = [self.universities objectAtIndex:self.chosenIndexPath.row];
        self.student.courses = [NSSet setWithArray:self.chosenCourses];
        [[RJDataManager sharedManager] saveContext];
    }
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
        return [self.chosenCourses count];
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
            RJStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:firstNameField];
            if (!cell) {
                cell = [[RJStudentProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:firstNameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstNameField.text = self.firstName;
            self.nameCell = cell;
            return cell;
        } else if (indexPath.row == 1) {
            RJStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:lastNameField];
            if (!cell) {
                cell = [[RJStudentProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lastNameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.surnameCell = cell;
            cell.lastNameField.text = self.lastName;
            return cell;
        } else if (indexPath.row == 2) {
            RJStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreField];
            if (!cell) {
                cell = [[RJStudentProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scoreField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.newStudent) {
                cell.intScoreField.text = [NSString stringWithFormat:@"%ld", [self.score integerValue]];
                cell.decimalScoreField.text = [[NSString stringWithFormat:@"%.2f", [self.score floatValue]] substringFromIndex:2];
            }
            self.scoreCell = cell;
            return cell;
        } else if (indexPath.row == 3) {
            RJStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:universityField];
            if (!cell) {
                cell = [[RJStudentProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:universityField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.universityField.text = self.university.name;
            self.universityCell = cell;
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCourseField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newCourseField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        }
    } else {
        RJStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:coursesField];
        if (!cell) {
            cell = [[RJStudentProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:coursesField];
        }
        RJCourse *course = [self.chosenCourses objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.coursesLabel.text = course.name;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPredicate *coursesPredicate = [NSPredicate predicateWithFormat:@"university == %@", self.chosenUniversity];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.courses = [self getAllObjectsWithEntityName:@"RJCourse" predicate:coursesPredicate andSortDescriptors:@[nameDescriptor]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"NewCourse"]) {
        if (!self.chosenUniversity) {
            [self showChooseUniversityAlert];
        } else {
            RJCoursesSelectionController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCourses"];
            vc.previousController = self;
            vc.delegate = self;
            vc.courses = self.courses;
            if (self.chosenCourses) {
                vc.indexPathForChosenCourses = self.indexPathForChosenCourses;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == RJFieldTypeUniversityField) {
        RJUniversitySelectionController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseUniversity"];
        vc.previousController = self;
        vc.delegate = self;
        vc.universities = self.universities;
        if (self.chosenUniversity) {
            vc.lastIndexPath = self.chosenIndexPath;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == RJFieldTypeDecimalScoreField) {
        return [textField resignFirstResponder];
    } else {
        return [textField resignFirstResponder] && [[self.tableView viewWithTag:textField.tag +1] becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == RJFieldTypeIntScoreField) {
        return [self setScoreMaskForTextField:textField InRange:range replacementString:string withMaxLenth:1];
    } else if (textField.tag == RJFieldTypeDecimalScoreField) {
        return [self setScoreMaskForTextField:textField InRange:range replacementString:string withMaxLenth:2];
    } else {
        return YES;
    }
}

#pragma mark - Methods

- (BOOL)setScoreMaskForTextField:(UITextField *)textField InRange:(NSRange)range replacementString:(NSString *)string withMaxLenth:(NSInteger)maxLenth{
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    if ([newString length] > maxLenth) {
        return  NO;
    }
    
    return YES;
}

- (void)showChooseUniversityAlert {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Please, choose university first" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}

- (NSArray *)getAllObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)descriptors {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:predicate];
    [request setSortDescriptors:descriptors];
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    return resultArray;
}

- (void)saveData {
    self.firstName = self.nameCell.firstNameField.text;
    self.lastName = self.surnameCell.lastNameField.text;
    self.score = [NSNumber numberWithFloat:[self.scoreCell.intScoreField.text integerValue] + [self.scoreCell.decimalScoreField.text floatValue] / 100];
    self.university = [self.universities objectAtIndex:self.chosenIndexPath.row];
}

- (void)loadData {
    self.nameCell.firstNameField.text = self.firstName;
    self.surnameCell.lastNameField.text = self.lastName;
    self.scoreCell.intScoreField.text = [NSString stringWithFormat:@"%ld", [self.score integerValue]];
    self.scoreCell.decimalScoreField.text = [[NSString stringWithFormat:@"%.2f", [self.score floatValue]] substringFromIndex:2];
    self.universityCell.universityField.text = self.university.name;
}

#pragma mark - RJUniversityDelegate

- (void)didChooseUniversity:(RJUniversity *)university atIndexPath:(NSIndexPath *)indexPath {
    if (![self.chosenUniversity isEqual:university]) {
        [[self mutableArrayValueForKey:@"chosenCourses"] removeAllObjects];
        if (self.indexPathForChosenCourses) {
            [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] removeAllObjects];
        }
    }
    self.chosenUniversity = university;
    self.universityCell.universityField.text = university.name;
    self.chosenIndexPath = indexPath;
}

#pragma mark - RJCourseDelegate

- (void)didChooseCoursesAtIndexPath:(NSArray *)indexPaths {
    [[self mutableArrayValueForKey:@"chosenCourses"] removeAllObjects];
    self.indexPathForChosenCourses = indexPaths;
    for (NSIndexPath *indexPath in indexPaths) {
        [[self mutableArrayValueForKey:@"chosenCourses"] addObject:[self.courses objectAtIndex:indexPath.row]];
    }
    [self saveData];
    [self.tableView reloadData];
    [self loadData];
}

@end
