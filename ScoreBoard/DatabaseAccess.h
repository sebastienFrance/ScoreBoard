//
//  DatabaseAccess.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObjectModel;
@class NSManagedObjectContext;
@class NSPersistentStoreCoordinator;

@interface DatabaseAccess : NSObject

@property (nonatomic,  readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,  readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,  readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

+ (DatabaseAccess*)sharedManager;

@end
