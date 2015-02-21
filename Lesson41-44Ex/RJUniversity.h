//
//  RJUniversity.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RJObject.h"

@class RJCourse, RJProfessor, RJStudent;

@interface RJUniversity : RJObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) NSSet *professors;
@property (nonatomic, retain) NSSet *students;
@end

@interface RJUniversity (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(RJCourse *)value;
- (void)removeCoursesObject:(RJCourse *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

- (void)addProfessorsObject:(RJProfessor *)value;
- (void)removeProfessorsObject:(RJProfessor *)value;
- (void)addProfessors:(NSSet *)values;
- (void)removeProfessors:(NSSet *)values;

- (void)addStudentsObject:(RJStudent *)value;
- (void)removeStudentsObject:(RJStudent *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
