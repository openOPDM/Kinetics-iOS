//
//  DBManager.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/21/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "DBManager.h"
#import <CoreData/CoreData.h>
#include <AssertMacros.h>

@interface DBManager ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) dispatch_queue_t coreDataQueue;
@end

@implementation DBManager

+(DBManager*)sharedDatabase
{
	static DBManager *instance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		instance = [[DBManager alloc] init];
		instance.coreDataQueue = dispatch_queue_create("MD CoreData Queue", DISPATCH_QUEUE_SERIAL);
		
		//init
		dispatch_sync(instance.coreDataQueue, ^{
			[instance initCoreDataDB];
		});
		
	});
	
	return instance;
}

-(void)initCoreDataDB
{
    //	check(dispatch_get_current_queue() == self.coreDataQueue);
	
	self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	NSString *dbFilePath = nil;
	
	if(self.managedObjectModel)
    {
        NSError *theError;
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
        
        // Allow inferred migration from the original version of the application.
        NSDictionary *theOptions = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                    NSInferMappingModelAutomaticallyOption: @YES};
        
		NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		dbFilePath = [path stringByAppendingPathComponent:@"MobilityData.sqlite"];
		NSURL *theStoreUrl = [NSURL fileURLWithPath:dbFilePath];
		
        if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
														   configuration:nil
																	 URL:theStoreUrl
																 options:theOptions
																   error:&theError])
        {
            
#if DEBUG
            if(theError)
            {
				dispatch_async(dispatch_get_main_queue(), ^{
					NSLog(@"Error creating persistent store - %@", theError);
				});
            }
#endif
			return;
        }
    }
    
    if(self.persistentStoreCoordinator)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator: self.persistentStoreCoordinator];
        [self.managedObjectContext setUndoManager:nil];
		
#if DEBUG
        dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"DB has successfully created at path - %@", dbFilePath);
		});
#endif
		
    }
}


- (NSArray*)getAllDataForEntity:(NSString*)anEntity withPredicate:(NSPredicate*)aPredicate{
    
    __block id result = nil;
	__weak DBManager *this = self;
	
	dispatch_sync(self.coreDataQueue, ^{
		result = [this doReadAllEntities:(NSString*)anEntity withPredicate:aPredicate];
	});
	
	return result;
}

-(NSArray*)doReadAllEntities:(NSString*)anEntity withPredicate:aPredicate{
    
    NSArray *allSavedNotes = nil;
	
	NSFetchRequest *theRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *theEntity = [NSEntityDescription entityForName:anEntity
												 inManagedObjectContext:self.managedObjectContext];
	
	if(!theEntity) {
		return nil;
	}
	
	[theRequest setEntity:theEntity];
    [theRequest setPredicate:aPredicate];
	
	NSError *theError = nil;
	allSavedNotes = [self.managedObjectContext executeFetchRequest:theRequest error:&theError];
	
#if DEBUG
    if(theError)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"Error reading notes from DB: %@", theError);
		});
	}
#endif
	
	return allSavedNotes;
}


-(void)deleteAllDataForEntity:(NSString*)anEntity withPredicate:(NSPredicate*)aPredicate{
   
    NSArray *theArray = [[DBManager sharedDatabase] getAllDataForEntity:anEntity withPredicate:aPredicate];
    
    for (NSManagedObject* theEnt in theArray) {
        
        [self deleteObject:theEnt];
    }
}


-(BOOL)deleteObject:(id)anObject
{
	__block BOOL result = NO;
	__weak DBManager *this = self;
	
	dispatch_sync(self.coreDataQueue, ^{
		result = [this doDeleteObject:anObject];
	});
	
	return result;
}

-(BOOL)doDeleteObject:(id)anObject
{
    //	check(dispatch_get_current_queue() == self.coreDataQueue);
	
	[self.managedObjectContext deleteObject:anObject];
	return [self doSaveObject:anObject];
}

-(BOOL)doSaveObject:(id)anObject
{
    //	check(dispatch_get_current_queue() == self.coreDataQueue);
	
	NSError *err = nil;
	if (![self.managedObjectContext save:&err]) {
        
#if DEBUG
        NSManagedObject *mObject = anObject;
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"Error while trying to save entity '%@' - %@", mObject.entity.name, err);
		});
#endif
		return NO;
	}
	
	return YES;
}

- (void)updateEntity{
    
    
    __block BOOL result = NO;
	__weak DBManager *this = self;
	
	dispatch_sync(self.coreDataQueue, ^{
		result = [this doSaveObject:nil];
	});
	
#ifdef DEBUG
    
    if (result) {
        NSLog(@"updated");
    }
    else{
        NSLog(@"error while updating");
    }

#endif
   
}

-(id)newObjectForEntityName:(NSString*)name
{
	__block id result = nil;
	__weak DBManager *this = self;
	
	dispatch_sync(self.coreDataQueue, ^{
		result = [this doNewObjectForEntityName:name];
	});
	
	return result;
}

-(id)doNewObjectForEntityName:(NSString*)name
{
    //	check(dispatch_get_current_queue() == self.coreDataQueue);
	
	if (name == nil || [name isEqualToString:@""]) return nil;
	
	return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
}

@end
