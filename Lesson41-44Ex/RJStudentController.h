//
//  RJStudentController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCoreDataTableViewController.h"

@interface RJStudentController : RJCoreDataTableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)actionAddStudent:(id)sender;
- (IBAction)actionControllStateChanged:(id)sender;
@end
