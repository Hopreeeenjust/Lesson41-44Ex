//
//  RJDataManager.m
//  Lesson41-44Ex
//
//  Created by Hopreeeeenjust on 15.02.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJDataManager.h"
#import "RJCoreDataTableViewController.h"
#import "RJUniversity.h"
#import "RJStudent.h"
#import "RJCourse.h"
#import "RJProfessor.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

@implementation RJDataManager

+ (RJDataManager *)sharedManager {
    static RJDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RJDataManager new];
    });
    return manager;
}

#pragma mark - Adding objects 

- (RJUniversity *)addUniversity {
    RJUniversity *university = [NSEntityDescription insertNewObjectForEntityForName:@"RJUniversity" inManagedObjectContext:self.managedObjectContext];
    university.name = @"ONPU";
    return university;
}

- (RJStudent *)addRandomStudent {
    RJStudent *student = [NSEntityDescription insertNewObjectForEntityForName:@"RJStudent" inManagedObjectContext:self.managedObjectContext];
    student.score = @((float)arc4random_uniform(701) / 100.f + 3.f);
    student.firstName = firstNames[arc4random_uniform(50)];
    student.lastName = lastNames[arc4random_uniform(50)];
    return student;
}

- (RJCourse *)addCourseWithName:(NSString *)name {
    RJCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    course.name = name;
    return course;
}

- (void)checkCoursesForDelete {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"students.@count == %d", nil];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *allCoursesToDelete = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (RJCourse *course in allCoursesToDelete) {
        [self.managedObjectContext deleteObject:course];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Roman-Jouravkov.Lesson41_44Ex" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lesson41_44Ex" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Lesson41_44Ex.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
//        [self checkCoursesForDelete];
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            NSLog(@"abort");
            abort();
        }
    }
}

- (void)updateContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        [managedObjectContext updatedObjects];
    }
}

- (void)a {
//    NSArray *cources = @[[self addCourseWithName:@"iOS"],
//                         [self addCourseWithName:@"Android"],
//                         [self addCourseWithName:@"PHP"],
//                         [self addCourseWithName:@"Javascript"],
//                         [self addCourseWithName:@"HTML"]];
    RJUniversity *mit = [NSEntityDescription insertNewObjectForEntityForName:@"RJUniversity" inManagedObjectContext:self.managedObjectContext];
    mit.name = @"BSEU";
    mit.country = @"Belarus";
    mit.city = @"Minsk";
    mit.rank = [NSNumber numberWithInteger:925];
    RJCourse *swift = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    swift.name = @"Statistics";
    swift.field = @"Exact science";
    swift.object = @"Statistics";
    swift.university = mit;
    RJProfessor *pr1 = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
    pr1.firstName = @"Svetlana";
    pr1.lastName = @"Belova";
    swift.professor = pr1;
    RJCourse *iOS = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    iOS.name = @"Micro Economics";
    iOS.field = @"Economins";
    iOS.object = @"Economic theory";
    iOS.university = mit;
//    RJProfessor *pr2 = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
//    pr2.firstName = @"Albert";
//    pr2.lastName = @"Einstein";
    iOS.professor = pr1;
    RJCourse *php = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    php.name = @"Basics of jurisprudence";
    php.field = @"Law";
    php.object = @"Jurisprudence";
    php.university = mit;
    RJProfessor *pr3 = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
    pr3.firstName = @"Oleg";
    pr3.lastName = @"Petrov";
    php.professor = pr3;
//    RJCourse *android = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
//    android.name = @"Pharmacology";
//    android.field = @"Medicine";
//    android.object = @"Pharmacology";
//    android.university = mit;
//    RJProfessor *pr5 = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
//    pr5.firstName = @"Carine";
//    pr5.lastName = @"Roitfeld";
//    android.professor = pr5;
    RJCourse *ai = [NSEntityDescription insertNewObjectForEntityForName:@"RJCourse" inManagedObjectContext:self.managedObjectContext];
    ai.name = @"English language";
    ai.field = @"Humanities";
    ai.object = @"Linguistics";
    ai.university = mit;
    RJProfessor *pr4 = [NSEntityDescription insertNewObjectForEntityForName:@"RJProfessor" inManagedObjectContext:self.managedObjectContext];
    pr4.firstName = @"Veronika";
    pr4.lastName = @"Tihonchuk";
    ai.professor = pr4;
    [mit addProfessors:[NSSet setWithArray:@[pr1, pr3, pr4, pr4]]];
    NSArray *courses = @[swift, iOS, php, ai];
    for (int i = 0; i < 25; i++) {
        RJStudent *student = [self addRandomStudent];
        [mit addStudentsObject:student];
        NSInteger number = arc4random_uniform(4) + 1;
        while ([student.courses count] < number) {
            RJCourse *course = [courses objectAtIndex:arc4random_uniform(4)];
            if (![student.courses containsObject:course]) {
                [student addCoursesObject:course];
            }
        }
    }
}

@end
