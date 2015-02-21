//
//  RJDataManager.h
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 15.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RJUniversity;

@interface RJDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)updateContext;
- (NSURL *)applicationDocumentsDirectory;

+ (RJDataManager *)sharedManager;

@end
