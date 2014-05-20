//
//  CDManagerSuperclass.h
//  BooklMegaMaster
//
//  Created by CAwesome on 2014-03-22.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDManagerSuperclass : NSObject

-(NSArray*)performFetch:(NSFetchRequest*)fetchRequest;



- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
-(id)CDObjectFromEntityName:(NSString*)entity;
-(id)CDObjectFromEntityName:(NSString *)entity inMOC:(NSManagedObjectContext*)moc;
-(void)saveSingelMOC:(NSManagedObjectContext*)managedObjectContext;

@end
