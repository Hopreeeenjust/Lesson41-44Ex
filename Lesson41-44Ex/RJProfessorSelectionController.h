//
//  RJProfessorSelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 19.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJProfessor;
@protocol RJProfessorDelegate;

@interface RJProfessorSelectionController : UITableViewController
@property (strong, nonatomic) NSArray *professors;
@property (strong, nonatomic) UITableViewController *previousController;

@property (weak, nonatomic) id <RJProfessorDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) RJProfessor *professor;

- (IBAction)actionSaveButtonPushed:(UIBarButtonItem *)sender;
@end

@protocol RJProfessorDelegate <NSObject>
- (void)didChooseProfessor:(RJProfessor *)professor atIndexPath:(NSIndexPath *)indexPath;
@end
