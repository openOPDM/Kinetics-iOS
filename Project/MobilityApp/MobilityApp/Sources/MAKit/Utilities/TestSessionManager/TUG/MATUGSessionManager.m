//
//  MATUGSessionManager.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/27/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATUGSessionManager.h"

#import <CoreMotion/CoreMotion.h>

#import "AccelerometerFilter.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"

static const NSTimeInterval kMATUGSessionWarmUpIntervalValue = 3.0;
static const NSTimeInterval kMATUGSessionCountZeroValue = 20.0;
static const NSTimeInterval kMATUGSessionBoundZeroValue = 0.05;

@interface MATUGSessionManager ()
{
    NSTimeInterval _interval;
    NSTimeInterval _startInterval;
    NSTimeInterval _stopInterval;
    NSTimeInterval _dStartInterval;
    NSTimeInterval _dStopInterval;
    
    int _countZero;
}

@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) NSOperationQueue *motionUpdatesQueue;

@property (nonatomic) AccelerometerFilter *filter;

@end

@implementation MATUGSessionManager

#pragma mark -
#pragma mark Singleton

MA_SINGLETON_SYNTHESIZE(MATUGSessionManager, sharedManager);

#pragma mark -
#pragma mark Object Lfiecycle

- (instancetype)init
{
    self = [super init];
    
    if (self != nil)
    {
        _motionManager = [CMMotionManager new];
        
        _motionUpdatesQueue = [NSOperationQueue new];
        [_motionUpdatesQueue setMaxConcurrentOperationCount:1];
        [_motionUpdatesQueue setName:@"com.Kinetics.Mobility.TUGTestSessionQueue"];
    }
    
    return self;
}

#pragma mark -
#pragma mark Overridden Methods

- (void)startTestSessionWithDeviceMotionUpdateInterval:(NSTimeInterval)interval
{
    if ([self isTestSessionStarted])
    {
        [self cancelTestSession];
    }
    
    self.testSessionStarted = YES;
    
    [self testSessionDidStart];
    
    if ([self.motionManager isDeviceMotionAvailable])
    {
        self.filter = [[LowpassFilter alloc] initWithSampleRate:interval cutoffFrequency:5.0];
        self.filter.adaptive = YES;
        
        [self.motionManager setDeviceMotionUpdateInterval:interval];
        [self.motionManager startDeviceMotionUpdatesToQueue:self.motionUpdatesQueue withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
        {
            [self handleDeviceMotion:deviceMotion];
        }];
    }
}

- (void)stopTestSession
{
    if ([self isTestSessionStarted])
    {
        self.testSessionStarted = NO;
        [self.motionManager stopDeviceMotionUpdates];
        
        [self testSessionDidFinish];
    }
}

- (void)cancelTestSession
{
    if ([self isTestSessionStarted])
    {
        self.testSessionStarted = NO;
        [self.motionManager stopDeviceMotionUpdates];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)testSessionDidStart
{
    _interval = 0.0;
    _startInterval = 0.0;
    _stopInterval = 0.0;
    _dStartInterval = 0.0;
    _dStopInterval = 0.0;
    
    _countZero = 0;
}

- (void)testSessionDidProgress
{
    _interval = _stopInterval - _startInterval;
    
    if (self.testSessionProgressBlock != nil)
    {
        self.testSessionProgressBlock(_interval);
    }
}

- (void)testSessionDidFinish
{
    if (self.testSessionCompletionBlock != nil)
    {
        // Initialize Date string.
        NSString *creatinDateString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000.0];
        
        // Initialize interval value.
        _interval -= (_dStopInterval - _dStartInterval);
        
        // Initialize RAW data string.
        UIDevice *device = [UIDevice currentDevice];
        NSString *clientSystemInfoString = [NSString stringWithFormat:@"%@ %@ %@ %@", device.name, device.model, device.systemName, device.systemVersion];
        NSString *rawDataString = clientSystemInfoString;
        
        // Initialize test session.
        MATestSession *testSession = [MATestSession new];
        testSession.creationDate = creatinDateString;
        testSession.score = @(_interval);
        testSession.rawData = [MATestSessionRawData rawDataWithRawDataString:rawDataString];
        
        self.testSessionCompletionBlock(testSession);
    }
}

#pragma mark -
#pragma mark Helpers

- (void)handleDeviceMotion:(CMDeviceMotion *)motion
{
    if ([self isTestSessionStarted])
    {
        CMAcceleration acceleration = {motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z};
        NSTimeInterval t = motion.timestamp;
        
        if (_startInterval == 0)
        {
            _startInterval = t;
        }
        
        _stopInterval = t;
        
        [self.filter addAcceleration:acceleration];
        
        double fa[3] = {self.filter.fAccel.x, self.filter.fAccel.y, self.filter.fAccel.z};
        
        if (_interval < kMATUGSessionWarmUpIntervalValue ||
            fabs(fa[0]) > kMATUGSessionBoundZeroValue ||
            fabs(fa[1]) > kMATUGSessionBoundZeroValue ||
            fabs(fa[2]) > kMATUGSessionBoundZeroValue)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                [self testSessionDidProgress];
            });
            
            _countZero = 0;
        }
        else
        {
            _countZero++;
            
            if (_countZero == kMATUGSessionCountZeroValue)
            {
                _dStopInterval = t;
                
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    [self testSessionDidFinish];
                });
                
                _countZero = 0;
            }
            else if (_countZero == 1)
            {
                _dStartInterval = t;
            }
        }
    }
}

@end
