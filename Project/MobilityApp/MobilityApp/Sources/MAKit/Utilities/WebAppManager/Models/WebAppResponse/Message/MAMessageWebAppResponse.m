//
//  MAMessageWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAMessageWebAppResponse.h"

#import "MAConstants.h"

@implementation MAMessageWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self != nil)
    {
        _message = [MAWebAppResponse ma_object:self.data[kMAWebAppParameterMessageKey] validatingUsingClass:[NSString class]];
    }
    
    return self;
}

@end
