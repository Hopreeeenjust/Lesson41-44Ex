//
//  RJUniversityProfileController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJUniversity;

@interface RJUniversityProfileController : UITableViewController
@property (strong, nonatomic) RJUniversity *university;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (assign, nonatomic) NSNumber *rank;
@property (strong, nonatomic) NSSet *professorsSet;
@property (assign, nonatomic) BOOL newUniversity;

- (IBAction)actionDoneButtonPressed:(id)sender;
@end
