//
//  RJProfessorProfileCell.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 18.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJProfessorProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UILabel *universitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityForCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursesLabel;
@end
