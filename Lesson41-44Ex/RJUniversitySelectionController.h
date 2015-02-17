//
//  RJUniversitySelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 17.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJUniversityDelegate;

@interface RJUniversitySelectionController : UITableViewController
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) UITableViewController *previousController;

@property (weak, nonatomic) id <RJUniversityDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) NSString *university;

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender;
@end

@protocol RJUniversityDelegate <NSObject>
- (void)didChooseUniversity:(NSString *)university atIndexPath:(NSIndexPath *)indexPath;
@end
