//
//  RJUniversityProfileController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJUniversityProfileController.h"
#import "RJUniversityProfileCell.h"
#import "RJDataManager.h"
#import "RJUniversity.h"
#import "RJProfessor.h"
#import "RJCourse.h"
#import "RJProfessorsSelectionController.h"
#import "EMCCountryPickerController.h"

typedef NS_ENUM(NSInteger, RJFieldType) {
    RJFieldTypeNameField = 0,
    RJFieldTypeCountryField,
    RJFieldTypeCityField,
    RJFieldTypeRankField,
};

@interface RJUniversityProfileController ()<UITableViewDataSource, UITableViewDelegate, RJProfessorDelegate, EMCCountryDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) RJUniversityProfileCell *nameCell;
@property (strong, nonatomic) RJUniversityProfileCell *countryCell;
@property (strong, nonatomic) RJUniversityProfileCell *cityCell;
@property (strong, nonatomic) RJUniversityProfileCell *rankCell;

@property (strong, nonatomic) NSArray *professors; //all available professors in this country
@property (strong, nonatomic) NSArray *indexPathForChosenProfessors;
@property (strong, nonatomic) NSArray *chosenProfessors; //chosen professors for this university
@property (strong, nonatomic) EMCCountry *chosenCountry;
@property (strong, nonatomic) NSIndexPath *countryPath;

@end

@implementation RJUniversityProfileController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.professors = [NSArray new];
    self.indexPathForChosenProfessors = [NSArray new];
    self.chosenProfessors = [NSArray new];
    self.tableView.separatorColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    self.professors = [self getAllObjectsWithEntityName:@"RJProfessor" predicate:nil andSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    if (!self.newUniversity) {
        self.chosenProfessors = [[self.professorsSet allObjects] sortedArrayUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        for (RJProfessor *professor in self.chosenProfessors) {
            NSInteger rowOfChosenProfessor = [self.professors indexOfObject:professor];
            NSIndexPath *chosenCoursePath = [NSIndexPath indexPathForRow:rowOfChosenProfessor inSection:0];
            [[self mutableArrayValueForKey:@"indexPathForChosenProfessors"] addObject:chosenCoursePath];
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
    if (self.newUniversity) {
        RJUniversity *university = [NSEntityDescription insertNewObjectForEntityForName:@"RJUniversity" inManagedObjectContext:self.managedObjectContext];
        university.name = self.nameCell.nameField.text;
        university.country = self.countryCell.countryField.text;
        university.city = self.cityCell.cityField.text;
        university.rank = [NSNumber numberWithInteger:[self.rankCell.rankField.text integerValue]];
        university.professors = [NSSet setWithArray:self.chosenProfessors];
        [[RJDataManager sharedManager] saveContext];
    } else {
        self.university.name = self.nameCell.nameField.text;
        self.university.country = self.countryCell.countryField.text;
        self.university.city = self.cityCell.cityField.text;
        self.university.rank = [NSNumber numberWithInteger:[self.rankCell.rankField.text integerValue]];
        self.university.professors = [NSSet setWithArray:self.chosenProfessors];
        //if professor is no longer lecturing in this university we should delete courses of this university from his courses
        for (RJProfessor *professor in self.professors) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (RJCourse *course in professor.courses) {
                if ([[[professor.universities allObjects] valueForKeyPath:@"@unionOfSets.courses"] containsObject:course]) {
                    [tempArray addObject:course];
                } else {
                    continue;
                }
            }
            professor.courses = [NSSet setWithArray:tempArray];
        }
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
        return [self.chosenProfessors count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *nameField = @"Name";
    static NSString *countryField = @"Country";
    static NSString *cityField = @"City";
    static NSString *rankField = @"Rank";
    static NSString *addProfessorsField = @"AddProfessors";
    static NSString *professorsField = @"Professor";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RJUniversityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:nameField];
            if (!cell) {
                cell = [[RJUniversityProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nameField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameField.text = self.name;
            self.nameCell = cell;
            return cell;
        } else if (indexPath.row == 1) {
            RJUniversityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:countryField];
            if (!cell) {
                cell = [[RJUniversityProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:countryField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.countryCell = cell;
            cell.countryField.text = self.country;
            return cell;
        } else if (indexPath.row == 2) {
            RJUniversityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cityField];
            if (!cell) {
                cell = [[RJUniversityProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cityField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cityCell = cell;
            cell.cityField.text = self.city;
            return cell;
        } else if (indexPath.row == 3) {
            RJUniversityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:rankField];
            if (!cell) {
                cell = [[RJUniversityProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rankField];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.rank) {
                cell.rankField.text = [NSString stringWithFormat:@"%ld", [self.rank integerValue]];
            }
            self.rankCell = cell;
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addProfessorsField];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addProfessorsField];
            }
            return cell;
        }
    } else {
        RJUniversityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:professorsField];
        if (!cell) {
            cell = [[RJUniversityProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:professorsField];
        }
        RJProfessor *professor = [self.chosenProfessors objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.professorLabel.text = [NSString stringWithFormat:@"%@ %@", professor.firstName, professor.lastName];
        NSMutableString *tempString = [NSMutableString stringWithString:@"("];
        for (RJCourse *course in professor.courses) {
            if ([course isEqual:[[professor.courses allObjects] lastObject]]) {
                [tempString appendString:course.name];
            } else {
                [tempString appendFormat:@"%@, ", course.name];
            }
        }
        [tempString appendString:@")"];
        cell.coursesLabel.text = tempString;
        if ([professor.courses count] == 0) {
            cell.coursesLabel.text = @"(No courses yet)";
        }
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"University info data";
    } else {
        return @"Professors, who lectures in this university";
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 56.f;
    } else {
        return 44.f;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.country) {
        [self showChooseCountryAlert];
    } else {
        if ([cell.reuseIdentifier isEqualToString:@"AddProfessors"]) {
            NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            NSPredicate *predicate;
            if (!self.newUniversity) {
                predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(universities, $university, $university.country == %@) CONTAINS %@) OR universities.@count == %ld", self.country, self.university, 0];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(universities, $university, $university.country == %@).@count > 0 OR universities.@count == %ld", self.country, 0];
            }
            self.professors = [self getAllObjectsWithEntityName:@"RJProfessor" predicate:predicate andSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
            [[self mutableArrayValueForKey:@"indexPathForChosenProfessors"] removeAllObjects];
            for (RJProfessor *professor in self.chosenProfessors) {
                NSInteger rowOfChosenProfessor = [self.professors indexOfObject:professor];
                NSIndexPath *chosenCoursePath = [NSIndexPath indexPathForRow:rowOfChosenProfessor inSection:0];
                [[self mutableArrayValueForKey:@"indexPathForChosenProfessors"] addObject:chosenCoursePath];
            }

            RJProfessorsSelectionController *vc = [[RJProfessorsSelectionController alloc] initWithStyle:UITableViewStylePlain];
            vc.previousController = self;
            vc.delegate = self;
            vc.professors = self.professors;
            if (self.chosenProfessors) {
                vc.indexPathForChosenProfessors = self.indexPathForChosenProfessors;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == RJFieldTypeCountryField) {
        EMCCountryPickerController *vc = [[EMCCountryPickerController alloc] init];
        vc.countryDelegate = self;
        vc.showFlags = true;
        vc.drawFlagBorder = true;
        vc.flagBorderColor = [UIColor grayColor];
        vc.flagBorderWidth = 0.5f;
        vc.previousController = self;
        if (self.country) {
            vc.indexPath = self.countryPath;
            vc.currentCountry = self.chosenCountry;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == RJFieldTypeRankField) {
        return [self setScoreMaskForTextField:textField InRange:range replacementString:string withMaxLenth:3];
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

- (void)showChooseCountryAlert {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Please, choose country first" preferredStyle:UIAlertControllerStyleAlert];
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
    self.name = self.nameCell.nameField.text;
    self.country = self.countryCell.countryField.text;
    self.city = self.cityCell.cityField.text;
    self.rank = [NSNumber numberWithInteger:[self.rankCell.rankField.text integerValue]];
}

- (void)loadData {
    self.nameCell.nameField.text = self.name;
    self.countryCell.countryField.text = self.country;
    self.cityCell.cityField.text = self.city;
    self.rankCell.rankField.text = [NSString stringWithFormat:@"%ld", [self.rank integerValue]];
}

#pragma mark - EMCCountryDelegate

- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCountry atIndexPath:(NSIndexPath *)indexPath {
    self.chosenCountry = chosenCountry;
    self.country = chosenCountry.countryName;
    self.countryPath = indexPath;
    self.countryCell.countryField.text = chosenCountry.countryName;
    [self saveData];
    [self.tableView reloadData];
    [self loadData];
}

#pragma  mark - RJProfessorController

- (void)didChooseProfessorsAtIndexPath:(NSArray *)indexPaths {
    [[self mutableArrayValueForKey:@"chosenProfessors"] removeAllObjects];
    self.indexPathForChosenProfessors = indexPaths;
    for (NSIndexPath *indexPath in indexPaths) {
        [[self mutableArrayValueForKey:@"chosenProfessors"] addObject:[self.professors objectAtIndex:indexPath.row]];
    }
    [self saveData];
    [self.tableView reloadData];
    [self loadData];
}

@end
