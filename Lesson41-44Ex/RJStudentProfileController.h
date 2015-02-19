//
//  RJStudentProfileController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJStudent;
@class RJUniversity;

@interface RJStudentProfileController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) RJStudent *student;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) RJUniversity *university;
@property (strong, nonatomic) NSSet *coursesSet;
@property (assign, nonatomic) BOOL newStudent;

- (IBAction)actionDoneButtonPressed:(id)sender;
@end
