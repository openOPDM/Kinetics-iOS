//
//  MAKeychainItem.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAKeychainItem.h"

@implementation MAKeychainItem

#pragma mark -
#pragma mark Overridden methods

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:
            @" {Service: %@; Account: %@, Password: %@, Generic: %@}", self.service, self.account, self.password, self.generic];
}

@end
