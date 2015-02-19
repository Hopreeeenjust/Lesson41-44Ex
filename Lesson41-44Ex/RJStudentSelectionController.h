//
//  RJStudentSelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJStudentDelegate;

@interface RJStudentSelectionController : UITableViewController
@property (strong, nonatomic) NSArray *students;
@property (strong, nonatomic) UITableViewController *previousController;
@property (strong, nonatomic) NSArray *indexPathForChosenStudents;

@property (weak, nonatomic) id <RJStudentDelegate> delegate;

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender;
@end

@protocol RJStudentDelegate <NSObject>
- (void)didChooseStudentsAtIndexPath:(NSArray *)indexPaths;
@end
