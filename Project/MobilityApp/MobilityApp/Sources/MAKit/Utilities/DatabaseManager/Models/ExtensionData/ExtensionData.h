//
//  ExtensionData.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExtensionData : NSManagedObject

@property (nonatomic, retain) NSNumber * extensionID;
@property (nonatomic, retain) NSString * extensionType;
@property (nonatomic, retain) NSString * extensionValue;
@property (nonatomic, retain) NSString * extensionKey;

@end
