//
//  MATestSessionManager.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionManager.h"

#import "MAMacro.h"

@implementation MATestSessionManager

#pragma mark -
#pragma mark Singleton

+ (instancetype)sharedManager
{
    return nil;
}

#pragma mark -
#pragma mark Methods

- (void)startTestSessionWithDeviceMotionUpdateInterval:(NSTimeInterval)interval
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)stopTestSession
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancelTestSession
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
