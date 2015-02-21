//
//  RJStudentController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJStudentController.h"
#import "RJDataManager.h"
#import "RJStudent.h"
#import "RJUniversity.h"
#import "RJStudentProfileController.h"
#import "RJStudentInfoCell.h"

@interface RJStudentController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) NSSortDescriptor *universityDescriptor;
@property (strong, nonatomic) NSArray *indexesForHeader;
@end

@implementation RJStudentController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionNameKeyPath = @"firstLetter";
    self.universityDescriptor = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionAddStudent:(UIBarButtonItem *)sender {
     RJStudentProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEdit"];
    vc.newStudent = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionControllStateChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.sectionNameKeyPath = @"firstLetter";
        self.universityDescriptor = nil;
    } else {
        self.sectionNameKeyPath = @"university.name";
        self.universityDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"university.name" ascending:YES];
    }
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJStudent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [NSArray new];

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
    } else {
        sortDescriptors = @[self.universityDescriptor, firstNameDescriptor, lastNameDescriptor];
    }
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:self.sectionNameKeyPath
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(RJStudentInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RJStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.studentName.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.studentCourses.text = [NSString stringWithFormat:@"Courses: %ld", [student.courses count]];
    cell.studentScore.text = [NSString stringWithFormat:@"Score: %.2f", [student.score floatValue]];
    cell.studentUniversity.text = [NSString stringWithFormat:@"%@", student.university.name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (RJStudentInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"StudentCell";
    static NSString *identifierTwo = @"StudentCellInUniversitySection";
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        RJStudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RJStudentInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        RJStudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTwo];
        if (!cell) {
            cell = [[RJStudentInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierTwo];
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RJStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RJStudentProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEdit"];
    vc.student = student;
    vc.newStudent = NO;
    vc.firstName = student.firstName;
    vc.lastName = student.lastName;
    vc.score = student.score;
    vc.university = student.university;
    vc.coursesSet = student.courses;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
