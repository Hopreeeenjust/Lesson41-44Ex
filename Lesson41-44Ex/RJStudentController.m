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
#import "RJStudentProfileController.h"
#import "RJStudentInfoCell.h"

@interface RJStudentController ()
@property (strong, nonatomic) RJStudent *student;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RJStudentController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionAddStudent:(id)sender {
     RJStudentProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEdit"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[RJDataManager sharedManager] addUniversity];
//    [[RJDataManager sharedManager] saveContext];
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
    NSArray *sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
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
    cell.studentUniversity.text = [NSString stringWithFormat:@"%@", student.university];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}


#pragma mark - UITableViewDelegate

- (RJStudentInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"StudentInfo";
    RJStudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJStudentInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
