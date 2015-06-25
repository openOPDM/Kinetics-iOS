//
//  ExtensionMetadata.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExtensionMetadata : NSManagedObject

@property (nonatomic, retain) NSString * customer;
@property (nonatomic, retain) NSString * entityname;
@property (nonatomic, retain) NSNumber * extensionID;
@property (nonatomic, retain) NSString * extensionName;
@property (nonatomic, retain) NSString * extensionType;
@property (nonatomic, retain) NSString * extensionList;
@property (nonatomic, retain) NSString * extensionProperties;

@end
