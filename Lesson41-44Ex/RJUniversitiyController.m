//
//  RJUniversitiyController.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 15.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJUniversitiyController.h"
#import "RJDataManager.h"
#import "RJUniversity.h"

@interface RJUniversitiyController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RJUniversitiyController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionAddUniversity:(id)sender {
//    [[RJDataManager sharedManager] a];
//    [[RJDataManager sharedManager] saveContext];
    
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJUniversity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RJUniversity *university = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = university.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Students: %ld", [university.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
