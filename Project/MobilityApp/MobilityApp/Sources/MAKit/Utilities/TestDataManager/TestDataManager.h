//
//  TestDataManager.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 1/22/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "MASyncing.h"

@interface TestDataManager : NSObject

@property (nonatomic) id<MASyncing> delegate;
@property (nonatomic) NSDateFormatter *dateFormatter;

+ (TestDataManager *)sharedInstance;

- (void)storeTest:(NSDictionary*)aDict withTestState:(NSString*)aTestState forUser:(NSNumber*)theUser syncParam:(BOOL)aSchouldSync;
- (void)getExtensionsRequest;
- (void)synchroniseData;
- (void)syncWithTimer:(NSTimeInterval)aPeriod;
- (void)stopTimer;


- (NSString*)stringFromExtensions:(NSArray*)anArr;

@end
