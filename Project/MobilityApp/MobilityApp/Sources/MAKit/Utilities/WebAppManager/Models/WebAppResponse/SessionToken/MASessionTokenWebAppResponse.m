//
//  MASessionTokenWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MASessionTokenWebAppResponse.h"

#import "MAConstants.h"

@implementation MASessionTokenWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self != nil)
    {
        _sessionToken = [MAWebAppResponse ma_object:self.data[kMAWebAppParameterSessionTokenKey] validatingUsingClass:[NSString class]];
    }
    
    return self;
}

@end
