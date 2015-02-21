//
//  RJProfessorsSelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJProfessor;
@protocol RJProfessorDelegate;

@interface RJProfessorsSelectionController : UITableViewController
@property (strong, nonatomic) NSArray *professors;
@property (strong, nonatomic) UITableViewController *previousController;
@property (strong, nonatomic) NSArray *indexPathForChosenProfessors;

@property (weak, nonatomic) id <RJProfessorDelegate> delegate;
@end

@protocol RJProfessorDelegate <NSObject>
- (void)didChooseProfessorsAtIndexPath:(NSArray *)indexPaths;
@end
