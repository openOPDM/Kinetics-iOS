//
//  MAKeychainManager.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAKeychainItem;

@interface MAKeychainManager : NSObject

+ (BOOL)loadItem:(MAKeychainItem *)item;
+ (BOOL)saveItem:(MAKeychainItem *)item;
+ (BOOL)deleteItem:(MAKeychainItem *)item;

@end
