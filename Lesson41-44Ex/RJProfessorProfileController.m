//
//  RJProfessorProfileController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 18.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJProfessorProfileController.h"
#import "RJProfessorProfileCell.h"
#import "RJProfessor.h"
#import "RJDataManager.h"
#import "RJUniversity.h"
#import "RJCourse.h"
#import "RJUniversitiesSelectionController.h"
#import "RJCoursesSelectionController.h"

typedef NS_ENUM(NSInteger, RJFieldType) {
    RJFieldTypeNameField = 0,
    RJFieldTypeSurnameField,
};

@interface RJProfessorProfileController () <UITableViewDataSource, UITableViewDelegate, RJUniversityDelegate, RJCourseDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) RJProfessorProfileCell *nameCell;
@property (strong, nonatomic) RJProfessorProfileCell *surnameCell;

@property (strong, nonatomic) NSArray *indexPathForChosenUniversities;
@property (strong, nonatomic) NSArray *indexPathForChosenCourses;
@property (strong, nonatomic) NSArray *universities;        //all universities
@property (strong, nonatomic) NSArray *courses;      //all courses for selected universities
@property (strong, nonatomic) NSArray *chosenUniversities;    //chosen universities by professor
@property (strong, nonatomic) NSArray *chosenCourses;    //chosen courses by professor
@end

@implementation RJProfessorProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.universities = [NSArray new];
    self.courses = [NSArray new];
    self.chosenCourses = [NSArray new];
    self.chosenUniversities = [NSArray new];
    self.indexPathForChosenCourses = [NSArray new];
    self.indexPathForChosenUniversities = [NSArray new];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    
    self.universities = [self getAllObjectsWithEntityName:@"RJUniversity" predicate:nil andSortingKey:@"name"];
//    if (!self.newProfessor) {
//        self.chosenUniversity = self.university;
//        NSPredicate *coursesPredicate = [NSPredicate predicateWithFormat:@"university == %@", self.chosenUniversity];
//        self.courses = [self getAllObjectsWithEntityName:@"RJCourse" predicate:coursesPredicate andSortingKey:@"name"];
//        
//        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//        self.chosenCourses = [[self.coursesSet allObjects] sortedArrayUsingDescriptors:@[descriptor]];
//        for (RJCourse *course in self.chosenCourses) {
//            NSInteger rowOfChosenCourse = [self.courses indexOfObject:course];
//            NSIndexPath *chosenCoursePath = [NSIndexPath indexPathForRow:rowOfChosenCourse inSection:0];
//            [[self mutableArrayValueForKey:@"indexPathForChosenCourses"] addObject:chosenCoursePath];
//        }
//        NSInteger row = [self.universities indexOfObject:self.university];
//        self.chosenIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    }
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
    if (self.newProfessor) {
        RJProfessor *professor = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
        professor.firstName = self.nameCell.firstNameField.text;
        professor.lastName = self.surnameCell.lastNameField.text;
        professor.universities = [NSSet setWithArray:self.chosenUniversities];
        professor.courses = [NSSet setWithArray:self.chosenCourses];
        [[RJDataManager sharedManager] saveContext];
    } else {
        self.professor.firstName = self.nameCell.firstNameField.text;
        self.professor.lastName = self.surnameCell.lastNameField.text;
        self.professor.universities = [NSSet setWithArray:self.chosenUniversities];
        self.professor.courses = [NSSet setWithArray:self.chosenCourses];
        [[RJDataManager sharedManager] saveContext];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if ([self.chosenUniversities count] == 0) {
            return 3;
        } else {
            return [self.chosenUniversities count] + 1;
        }
    } else {
        return [self.chosenCourses count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *firstNameField = @"Name";
    static NSString *lastNameField = @"Surname";
    static NSString *chooseUniversityField = @"ChooseUniversity";
    static NSString *universitiesField = @"University";
    static NSString *chooseCourseField = @"ChooseCourse";
    static NSString *coursesField = @"Course";
    static NSString *emptyCell = @"EmptyCell";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RJProfessorProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:firstNameField];
            if (!cell) {
                cell = [[RJProfessorProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:firstNameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstNameField.text = self.firstName;
            self.nameCell = cell;
            return cell;
        } else if (indexPath.row == 1) {
            RJProfessorProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:lastNameField];
            if (!cell) {
                cell = [[RJProfessorProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lastNameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.surnameCell = cell;
            cell.lastNameField.text = self.lastName;
            return cell;
        } else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseUniversityField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chooseUniversityField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        }
    } else if (indexPath.section == 1 && [self.chosenUniversities count] > 0) {
        if (indexPath.row == [self.chosenUniversities count]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseCourseField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chooseCourseField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        } else {
            RJProfessorProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:universitiesField];
            if (!cell) {
                cell = [[RJProfessorProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:universitiesField];
            }
            RJUniversity *university = [self.chosenUniversities objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.universitiesLabel.text = university.name;
            return cell;
        }
    } else if (indexPath.section == 1 && [self.chosenUniversities count] == 0) {
        if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseCourseField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chooseCourseField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:emptyCell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        RJProfessorProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:coursesField];
        if (!cell) {
            cell = [[RJProfessorProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:coursesField];
        }
        RJCourse *course = [self.chosenCourses objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.coursesLabel.text = course.name;
        cell.universityForCourseLabel.text = course.university.name;
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Professor's personal data";
    } else if (section == 1) {
        return @"Professor's universities";
    } else {
        return @"Professor's courses";
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"ChooseUniversity"]) {
        self.universities = [self getAllObjectsWithEntityName:@"RJUniversity" predicate:nil andSortingKey:@"name"];
        RJUniversitiesSelectionController *vc = [[RJUniversitiesSelectionController alloc] initWithStyle:UITableViewStylePlain];
        vc.previousController = self;
        vc.delegate = self;
        vc.universities = self.universities;
        if (self.chosenUniversities) {
            vc.indexPathForChosenUniversities = self.indexPathForChosenUniversities;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"ChooseCourse"]) {
        if ([self.chosenUniversities count] == 0) {
            [self showChooseUniversityAlert];
        } else {
            self.courses = [self valueForKeyPath:@"chosenUniversities.@unionOfSets.courses"];
            NSSortDescriptor *universityDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"university.name" ascending:YES];
            NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *descriptors = @[universityDescriptor, nameDescriptor];
            self.courses = [self.courses sortedArrayUsingDescriptors:descriptors];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (RJCourse *course in self.courses) {
                if (course.professor == nil) {
                    [tempArray addObject:course];
                }
            }
            self.courses = tempArray;
//            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//            NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
//            [fetchRequest setEntity:entity];
//            
//            [fetchRequest setFetchBatchSize:20];
//            
//            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//            NSSortDescriptor *universityNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"university.name" ascending:YES];
//            NSArray *sortDescriptors = @[universityNameDescriptor, sortDescriptor];
//            [fetchRequest setSortDescriptors:sortDescriptors];
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"university IN %@ AND professor == nil" , self.chosenUniversities];
//            [fetchRequest setPredicate:predicate];
//            NSArray *courses = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == RJFieldTypeSurnameField) {
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

- (NSArray *)getAllObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate andSortingKey:(NSString *)key {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    return resultArray;
}

- (void)saveData {
    self.firstName = self.nameCell.firstNameField.text;
    self.lastName = self.surnameCell.lastNameField.text;
}

- (void)loadData {
    self.nameCell.firstNameField.text = self.firstName;
    self.surnameCell.lastNameField.text = self.lastName;
}
//
#pragma mark - RJUniversityDelegate

- (void)didChooseUniversitiesAtIndexPath:(NSArray *)indexPaths {
    [[self mutableArrayValueForKey:@"chosenUniversities"] removeAllObjects];
    self.indexPathForChosenUniversities = indexPaths;
    for (NSIndexPath *indexPath in indexPaths) {
        [[self mutableArrayValueForKey:@"chosenUniversities"] addObject:[self.universities objectAtIndex:indexPath.row]];
    }
    [self saveData];
    [self.tableView reloadData];
    [self loadData];
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
