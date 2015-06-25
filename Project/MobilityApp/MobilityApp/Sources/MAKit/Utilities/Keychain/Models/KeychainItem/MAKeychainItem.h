//
//  MAKeychainItem.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAKeychainItem : NSObject

@property (nonatomic, copy) NSString *service; // We assume that service and username must be equal.
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *generic;

@end
