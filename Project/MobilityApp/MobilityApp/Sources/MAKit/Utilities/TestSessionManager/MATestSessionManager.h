//
//  MATestSessionManager.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MATestSession;

typedef void (^MATestSessionCompletionBlock)(MATestSession *testSession);
typedef void (^MATestSessionProgressBlock)(NSTimeInterval timeInterval);

@interface MATestSessionManager : NSObject

@property (nonatomic, copy) MATestSessionCompletionBlock testSessionCompletionBlock;
@property (nonatomic, copy) MATestSessionProgressBlock testSessionProgressBlock;
@property (nonatomic, getter = isTestSessionStarted) BOOL testSessionStarted;

+ (instancetype)sharedManager;

- (void)startTestSessionWithDeviceMotionUpdateInterval:(NSTimeInterval)interval;
- (void)stopTestSession;
- (void)cancelTestSession;

@end
