//
//  RJProfessorProfileController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 18.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJProfessor;

@interface RJProfessorProfileController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) RJProfessor *professor;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSSet *universitiesSet;
@property (strong, nonatomic) NSSet *coursesSet;
@property (assign, nonatomic) BOOL newProfessor;
@end
