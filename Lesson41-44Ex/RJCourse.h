//
//  RJCourse.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 16.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RJObject.h"

@class RJProfessor, RJStudent, RJUniversity;

@interface RJCourse : RJObject

@property (nonatomic, retain) NSString * field;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * object;
@property (nonatomic, retain) RJProfessor *professor;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) RJUniversity *university;
@end

@interface RJCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(RJStudent *)value;
- (void)removeStudentsObject:(RJStudent *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
