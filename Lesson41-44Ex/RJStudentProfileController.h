//
//  RJStudentProfileController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJStudent;

@interface RJStudentProfileController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) RJStudent *student;

- (IBAction)actionDoneButtonPressed:(id)sender;

@end
