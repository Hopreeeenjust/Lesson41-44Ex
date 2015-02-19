//
//  RJUniversitiesSelectionController.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 18.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJUniversity;
@protocol RJUniversityDelegate;

@interface RJUniversitiesSelectionController : UITableViewController
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) UITableViewController *previousController;
@property (strong, nonatomic) NSArray *indexPathForChosenUniversities;

@property (weak, nonatomic) id <RJUniversityDelegate> delegate;
@end

@protocol RJUniversityDelegate <NSObject>
- (void)didChooseUniversitiesAtIndexPath:(NSArray *)indexPaths;
@end
