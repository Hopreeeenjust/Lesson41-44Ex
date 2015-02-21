//
//  RJStudent.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 20.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJStudent.h"
#import "RJCourse.h"
#import "RJUniversity.h"


@implementation RJStudent

@dynamic firstName;
@dynamic lastName;
@dynamic score;
@dynamic courses;
@dynamic university;

- (NSString *)firstLetter {
    [self willAccessValueForKey:@"firstLetter"];
    NSString *firstLetter = [[[self firstName] substringToIndex:1] uppercaseString];
    [self didAccessValueForKey:@"firstLetter"];
    return firstLetter;
}

@end
