//
//  RJCoursesSelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 17.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJCourseDelegate;

@interface RJCoursesSelectionController : UITableViewController
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) UITableViewController *previousController;
@property (strong, nonatomic) NSArray *indexPathForChosenCourses;

@property (weak, nonatomic) id <RJCourseDelegate> delegate;

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender;
@end

@protocol RJCourseDelegate <NSObject>
- (void)didChooseCoursesAtIndexPath:(NSArray *)indexPaths;
@end
