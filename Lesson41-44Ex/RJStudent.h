//
//  RJStudent.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RJObject.h"

@class RJCourse, RJUniversity;

@interface RJStudent : RJObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) RJUniversity *university;
@end

@interface RJStudent (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(RJCourse *)value;
- (void)removeCoursesObject:(RJCourse *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
