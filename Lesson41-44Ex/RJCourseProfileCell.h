//
//  RJCourseProfileCell.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJCourseProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *object;
@property (weak, nonatomic) IBOutlet UITextField *university;
@property (weak, nonatomic) IBOutlet UITextField *professor;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentScoreLabel;
@end
