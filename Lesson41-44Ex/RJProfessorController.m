//
//  RJProfessorController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJProfessorController.h"
#import "RJDataManager.h"
#import "RJProfessor.h"
#import "RJProfessorProfileController.h"
#import "RJProfessorInfoCell.h"

@interface RJProfessorController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RJProfessorController
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

- (IBAction)actionAddProfessor:(id)sender {
    RJProfessorProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfessorEdit"];
    vc.newProfessor = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
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

- (void)configureCell:(RJProfessorInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RJProfessor *professor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.professorName.text = [NSString stringWithFormat:@"%@ %@", professor.firstName, professor.lastName];
    if ([professor.courses count] == 1) {
        cell.profesorsCourses.text = [NSString stringWithFormat:@"Lectures on %ld course", [professor.courses count]];
    } else {
        cell.profesorsCourses.text = [NSString stringWithFormat:@"Lectures on %ld courses", [professor.courses count]];
    }
    cell.accessoryView.tintColor = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (RJProfessorInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ProfessorCell";
    RJProfessorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJProfessorInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    RJStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    RJStudentProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEdit"];
//    vc.student = student;
//    vc.newStudent = NO;
//    vc.firstName = student.firstName;
//    vc.lastName = student.lastName;
//    vc.score = student.score;
//    vc.university = student.university;
//    vc.coursesSet = student.courses;
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
