//
//  RJCourseProfileController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCourseProfileController.h"
#import "RJCourseProfileCell.h"
#import "RJCourse.h"
#import "RJDataManager.h"
#import "RJProfessor.h"
#import "RJUniversity.h"
#import "RJStudent.h"
#import "RJUniversitySelectionController.h"
#import "RJProfessorSelectionController.h"
#import "RJStudentSelectionController.h"

typedef NS_ENUM(NSInteger, RJFieldType) {
    RJFieldTypeFieldField = 0,
    RJFieldTypeNameField,
    RJFieldTypeObjectField,
    RJFieldTypeUniversityField,
    RJFieldTypeProfessorField,
};

@interface RJCourseProfileController () <UITableViewDataSource, UITableViewDelegate, RJUniversityDelegate, RJProfessorDelegate, RJStudentDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) RJCourseProfileCell *fieldCell;
@property (strong, nonatomic) RJCourseProfileCell *nameCell;
@property (strong, nonatomic) RJCourseProfileCell *objectCell;
@property (strong, nonatomic) RJCourseProfileCell *universityCell;
@property (strong, nonatomic) RJCourseProfileCell *professorCell;

@property (strong, nonatomic) RJUniversity *chosenUniversity;
@property (strong, nonatomic) RJProfessor *chosenProfessor;
@property (strong, nonatomic) NSIndexPath *chosenUniversityIndexPath;
@property (strong, nonatomic) NSIndexPath *chosenProfessorIndexPath;
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) NSArray *professors;
@property (strong, nonatomic) NSArray *students; //all available students
@property (strong, nonatomic) NSArray *indexPathForChosenStudents;
@property (strong, nonatomic) NSArray *chosenStudents;  //chosen students for this course
@end

@implementation RJCourseProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.universities = [NSArray new];
    self.professors = [NSArray new];
    self.students = [NSArray new];
    self.indexPathForChosenStudents = [NSArray new];
    self.chosenStudents = [NSArray new];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.universities = [self getAllObjectsWithEntityName:@"RJUniversity" predicate:nil andSortDescriptors:@[nameDescriptor]];
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    self.professors = [self getAllObjectsWithEntityName:@"RJProfessor" predicate:nil andSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];

    if (!self.newCourse) {
        self.chosenUniversity = self.university;
        self.chosenProfessor = self.professor;
        NSPredicate *studentsPredicate = [NSPredicate predicateWithFormat:@"university == %@", self.chosenUniversity];
        self.students = [self getAllObjectsWithEntityName:@"RJStudent" predicate:studentsPredicate andSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        self.chosenStudents = [[self.studentsSet allObjects] sortedArrayUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        for (RJStudent *student in self.chosenStudents) {
            NSInteger rowOfChosenStudent = [self.students indexOfObject:student];
            NSIndexPath *chosenStudentPath = [NSIndexPath indexPathForRow:rowOfChosenStudent inSection:0];
            [[self mutableArrayValueForKey:@"indexPathForChosenStudents"] addObject:chosenStudentPath];
        }
        NSInteger universityRow = [self.universities indexOfObject:self.university];
        self.chosenUniversityIndexPath = [NSIndexPath indexPathForRow:universityRow inSection:0];
        if (self.professor) {
            NSInteger professorRow = [self.professors indexOfObject:self.professor];
            self.chosenProfessorIndexPath = [NSIndexPath indexPathForRow:professorRow inSection:0];
        }
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
    if (self.newCourse) {
        RJCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
        course.field = self.fieldCell.field.text;
        course.name = self.nameCell.name.text;
        course.object = self.objectCell.object.text;
        course.university = [self.universities objectAtIndex:self.chosenUniversityIndexPath.row];
        if (self.chosenProfessorIndexPath) {
            course.professor = [self.professors objectAtIndex:self.chosenProfessorIndexPath.row];
        }
        course.students = [NSSet setWithArray:self.chosenStudents];
        [[RJDataManager sharedManager] saveContext];
    } else {
        self.course.field = self.fieldCell.field.text;
        self.course.name = self.nameCell.name.text;
        self.course.object = self.objectCell.object.text;
        self.course.university = [self.universities objectAtIndex:self.chosenUniversityIndexPath.row];
        if (self.chosenProfessorIndexPath) {
            self.course.professor = [self.professors objectAtIndex:self.chosenProfessorIndexPath.row];
        }
        self.course.students = [NSSet setWithArray:self.chosenStudents];
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
        return 6;
    } else {
        return [self.chosenStudents count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *fieldField = @"Field";
    static NSString *nameField = @"Name";
    static NSString *objectField = @"Object";
    static NSString *universityField = @"University";
    static NSString *professorField = @"Professor";
    static NSString *addStudentField = @"AddStudent";
    static NSString *studentsField = @"Student";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldField];
            if (!cell) {
                cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:fieldField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.field.text = self.field;
            self.fieldCell = cell;
            return cell;
        } else if (indexPath.row == 1) {
            RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:nameField];
            if (!cell) {
                cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.nameCell = cell;
            cell.name.text = self.name;
            return cell;
        } else if (indexPath.row == 2) {
            RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:objectField];
            if (!cell) {
                cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:objectField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.objectCell = cell;
            cell.object.text = self.object;
            return cell;
        } else if (indexPath.row == 3) {
            RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:universityField];
            if (!cell) {
                cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:universityField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.university.text = self.university.name;
            self.universityCell = cell;
            return cell;
        } else if (indexPath.row == 4) {
            RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:professorField];
            if (!cell) {
                cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:professorField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.professorCell = cell;
            if (self.professor) {
                cell.professor.text = [NSString stringWithFormat:@"%@ %@", self.professor.firstName, self.professor.lastName];
            }
            return cell;
        } else if (indexPath.row == 5) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addStudentField];
            }
            return cell;
        }
    } else {
        RJCourseProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:studentsField];
        if (!cell) {
            cell = [[RJCourseProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentsField];
        }
        RJStudent *student = [self.chosenStudents objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.studentScoreLabel.text = [NSString stringWithFormat:@"Score: %.2f", [student.score floatValue]];
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Courses info data";
    } else {
        return @"Students, who choose this course";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSPredicate *coursesPredicate = [NSPredicate predicateWithFormat:@"university == %@", self.chosenUniversity];
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    self.students = [self getAllObjectsWithEntityName:@"RJStudent" predicate:coursesPredicate andSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"AddStudent"]) {
        if (!self.chosenUniversity) {
            [self showChooseUniversityAlert];
        } else {
            RJStudentSelectionController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseStudents"];
            vc.previousController = self;
            vc.delegate = self;
            vc.students = self.students;
            if (self.chosenStudents) {
                vc.indexPathForChosenStudents = self.indexPathForChosenStudents;
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
            vc.lastIndexPath = self.chosenUniversityIndexPath;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if (textField.tag == RJFieldTypeProfessorField) {
        RJProfessorSelectionController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseProfessor"];
        vc.previousController = self;
        vc.delegate = self;
        vc.professors = self.professors;
        if (self.chosenProfessor) {
            vc.lastIndexPath = self.chosenProfessorIndexPath;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else {
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == RJFieldTypeObjectField) {
        return [textField resignFirstResponder];
    } else {
        return [textField resignFirstResponder] && [[self.tableView viewWithTag:textField.tag + 1] becomeFirstResponder];
    }
    return YES;
}

#pragma mark - Methods

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
    self.field = self.fieldCell.field.text;
    self.name = self.nameCell.name.text;
    self.object = self.objectCell.object.text;
    self.university = [self.universities objectAtIndex:self.chosenUniversityIndexPath.row];
    if (self.chosenProfessorIndexPath) {
        self.professor = [self.professors objectAtIndex:self.chosenProfessorIndexPath.row];
    }
}

- (void)loadData {
    self.fieldCell.field.text = self.field;
    self.nameCell.name.text = self.name;
    self.objectCell.object.text = self.object;
    self.universityCell.university.text = self.university.name;
    if (self.professor) {
        self.professorCell.professor.text = [NSString stringWithFormat:@"%@ %@", self.professor.firstName, self.professor.lastName];
    }
}

#pragma mark - RJUniversityDelegate

- (void)didChooseUniversity:(RJUniversity *)university atIndexPath:(NSIndexPath *)indexPath {
    if (![self.chosenUniversity isEqual:university]) {
        [[self mutableArrayValueForKey:@"chosenStudents"] removeAllObjects];
        if (self.indexPathForChosenStudents) {
            [[self mutableArrayValueForKey:@"indexPathForChosenStudents"] removeAllObjects];
        }
    }
    self.chosenUniversity = university;
    self.universityCell.university.text = university.name;
    self.chosenUniversityIndexPath = indexPath;
}

#pragma mark - RJProfessorDelegate

- (void)didChooseProfessor:(RJProfessor *)professor atIndexPath:(NSIndexPath *)indexPath {
    self.chosenProfessor = professor;
    self.professorCell.professor.text = [NSString stringWithFormat:@"%@ %@", professor.firstName, professor.lastName];
    self.chosenProfessorIndexPath = indexPath;
}

#pragma mark - RJStudentDelegate

- (void)didChooseStudentsAtIndexPath:(NSArray *)indexPaths {
    [[self mutableArrayValueForKey:@"chosenStudents"] removeAllObjects];
    self.indexPathForChosenStudents = indexPaths;
    for (NSIndexPath *indexPath in indexPaths) {
        [[self mutableArrayValueForKey:@"chosenStudents"] addObject:[self.students objectAtIndex:indexPath.row]];
    }
    [self saveData];
    [self.tableView reloadData];
    [self loadData];
}


@end
