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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RJCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Students on course: %ld", [course.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
