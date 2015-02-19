//
//  RJCourseProfileController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJProfessor;
@class RJUniversity;
@class RJCourse;

@interface RJCourseProfileController : UITableViewController
@property (strong, nonatomic) RJCourse *course;

@property (strong, nonatomic) NSString *field;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *object;
@property (strong, nonatomic) RJUniversity *university;
@property (strong, nonatomic) RJProfessor *professor;
@property (strong, nonatomic) NSSet *studentsSet;
@property (assign, nonatomic) BOOL newCourse;

- (IBAction)actionDoneButtonPressed:(id)sender;

@end
