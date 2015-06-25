//
//  TestData.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/4/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TestData : NSManagedObject

@property (nonatomic, retain) NSNumber * creationDate;
@property (nonatomic, retain) NSNumber * testID;
@property (nonatomic, retain) NSNumber * isValid;
@property (nonatomic, retain) NSString * rawData;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isSynchronised;
@property (nonatomic, retain) NSString * testState;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * extension;

@end
