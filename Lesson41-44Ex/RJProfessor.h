//
//  RJProfessor.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RJObject.h"

@class RJCourse, RJUniversity;

@interface RJProfessor : RJObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) NSSet *universities;
@end

@interface RJProfessor (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(RJCourse *)value;
- (void)removeCoursesObject:(RJCourse *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

- (void)addUniversitiesObject:(RJUniversity *)value;
- (void)removeUniversitiesObject:(RJUniversity *)value;
- (void)addUniversities:(NSSet *)values;
- (void)removeUniversities:(NSSet *)values;

@end
