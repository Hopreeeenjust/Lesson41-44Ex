//
//  RJStudentProfileCell.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJStudentProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *intScoreField;
@property (weak, nonatomic) IBOutlet UITextField *decimalScoreField;
@property (weak, nonatomic) IBOutlet UITextField *universityField;
@property (weak, nonatomic) IBOutlet UILabel *coursesLabel;

@end
