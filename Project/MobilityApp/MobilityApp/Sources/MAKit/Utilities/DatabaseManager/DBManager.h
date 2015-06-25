//
//  DBManager.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/21/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


+(DBManager*)sharedDatabase;


- (id)newObjectForEntityName:(NSString*)name;
- (NSArray*)getAllDataForEntity:(NSString*)anEntity withPredicate:(NSPredicate*)aPredicate;
- (void)deleteAllDataForEntity:(NSString*)anEntity withPredicate:(NSPredicate*)aPredicate;
- (void)updateEntity;

@end
