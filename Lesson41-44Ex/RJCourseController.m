//
//  RJCourseController
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCourseController.h"
#import "RJDataManager.h"
#import "RJCourse.h"
#import "RJCourseProfileController.h"
#import "RJCourseInfoCell.h"

@interface RJCourseController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RJCourseController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionAddCourse:(id)sender {
    RJCourseProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseEdit"];
    vc.newCourse = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *universityNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"university.name" ascending:YES];

    NSArray *sortDescriptors = @[universityNameDescriptor, sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:@"university.name"
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

- (void)configureCell:(RJCourseInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RJCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.courseName.text = course.name;
    if (course.professor) {
        cell.courseAttendance.text = [NSString stringWithFormat:@"Students on course: %ld", [course.students count]];
    } else {
        cell.courseAttendance.text = [NSString stringWithFormat:@"Applications for course: %ld", [course.students count]];
    }
    cell.courseField.text = course.field;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CourseCell";
    RJCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJCourseInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
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
    RJCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RJCourseProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseEdit"];
    vc.course = course;
    vc.newCourse = NO;
    vc.field = course.field;
    vc.name = course.name;
    vc.object = course.object;
    vc.university = course.university;
    vc.professor = course.professor;
    vc.studentsSet = course.students;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    if ([anObject isKindOfClass:[RJCourse class]]) {
        RJCourse *course = (RJCourse *)anObject;
        if ([course.students count] == 0) {
            [self.managedObjectContext deleteObject:course];
        }
    }
}



@end
