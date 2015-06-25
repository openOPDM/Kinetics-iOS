//
//  MAPSTSessionManager.mm
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAPSTSessionManager.h"

#import <CoreMotion/CoreMotion.h>
#import <DSPFilters/Dsp.h>
#include <vector>

#import "MAPST.hpp"

#import "MATestSession.h"
#import "MATestSessionRawData.h"

const NSTimeInterval kMAPSTSessionDuration = 30.0;

static NSString * const kMAPSTSessionProgressUserInfoKey = @"MAPSTSessionProgressUserInfoKey";

@interface MAPSTSessionManager ()
{
    std::vector<double> _x;
    std::vector<double> _y;
    std::vector<double> _z;
    std::vector<double> _t;
}

@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) NSOperationQueue *motionUpdatesQueue;

@property (nonatomic) NSTimer *testSessionTimer;

@end

@implementation MAPSTSessionManager

#pragma mark -
#pragma mark Singleton

MA_SINGLETON_SYNTHESIZE(MAPSTSessionManager, sharedManager);

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
        [_motionUpdatesQueue setName:@"com.Kinetics.Mobility.PSTTestSessionQueue"];
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
        self.testSessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(testSessionDidProgress:)
                                                               userInfo:[@{kMAPSTSessionProgressUserInfoKey: @(kMAPSTSessionDuration)} mutableCopy]
                                                                repeats:YES];
        
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
        
        [self.testSessionTimer invalidate];
        self.testSessionTimer = nil;
        
        [self testSessionDidFinish];
    }
}

- (void)cancelTestSession
{
    if ([self isTestSessionStarted])
    {
        self.testSessionStarted = NO;
        [self.motionManager stopDeviceMotionUpdates];
        
        [self.testSessionTimer invalidate];
        self.testSessionTimer = nil;
    }
}

#pragma mark -
#pragma mark Accessors

- (double)calibratedAREAValue
{
    double area = [[NSUserDefaults standardUserDefaults] doubleForKey:kMAUserDefaultsPSTAREACalibrationValueKey];
    
    return area != 0.0 ? area : 1.0;
}

- (void)setCalibratedAREAValue:(double)calibratedAREAValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:calibratedAREAValue forKey:kMAUserDefaultsPSTAREACalibrationValueKey];
    [userDefaults synchronize];
}

- (double)calibratedJERKValue
{
    double jerk = [[NSUserDefaults standardUserDefaults] doubleForKey:kMAUserDefaultsPSTJERKCalibrationValueKey];
    
    return jerk != 0.0 ? jerk : 1.0;
}

- (void)setCalibratedJERKValue:(double)calibratedJERKValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:calibratedJERKValue forKey:kMAUserDefaultsPSTJERKCalibrationValueKey];
    [userDefaults synchronize];
}

- (double)calibratedRMSValue
{
    double rms = [[NSUserDefaults standardUserDefaults] doubleForKey:kMAUserDefaultsPSTRMSCalibrationValueKey];
    
    return rms != 0.0 ? rms : 1.0;
}

- (void)setCalibratedRMSValue:(double)calibratedRMSValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:calibratedRMSValue forKey:kMAUserDefaultsPSTRMSCalibrationValueKey];
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark Methods

- (void)resetCalibratedValues
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:kMAUserDefaultsPSTAREACalibrationValueKey];
    [userDefaults removeObjectForKey:kMAUserDefaultsPSTJERKCalibrationValueKey];
    [userDefaults removeObjectForKey:kMAUserDefaultsPSTRMSCalibrationValueKey];
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark Timer Actions

- (void)testSessionDidProgress:(NSTimer *)timer
{
    if ([timer isValid])
    {
        NSMutableDictionary *userInfo = [timer userInfo];
        NSTimeInterval secondsLeft = [userInfo[kMAPSTSessionProgressUserInfoKey] doubleValue] - 1.0;
        
        userInfo[kMAPSTSessionProgressUserInfoKey] = @(secondsLeft);
        
        if (self.testSessionProgressBlock != nil)
        {
            self.testSessionProgressBlock(secondsLeft);
        }
        
        if (secondsLeft == 0.0)
        {
            [self stopTestSession];
        }
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)testSessionDidStart
{
    _x.resize(0);
    _y.resize(0);
    _z.resize(0);
    _t.resize(0);
}

- (void)testSessionDidFinish
{
    if (self.testSessionCompletionBlock != nil)
    {
        // Initialize Date string.
        NSString *creatinDateString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000.0];
        
        // Initialize values string.
        NSMutableString *valuesString = [NSMutableString string];
        
        for (NSUInteger index = 0; index < _t.size(); index++)
        {
            [valuesString appendFormat:@",%@", [NSString stringWithFormat:@"%f,%f,%f,%f", _x[index], _y[index], _z[index], _t[index]]];
        }
        
        // Initialize JERK, AREA and RMS values.
        double frequency = 1.0 / (_t[1] - _t[0]);
        double *axises[3] = {_x.data(), _y.data(), _z.data()};
        
        Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, 3> low_pass;
        low_pass.setup(4, frequency, 3.75);
        low_pass.process((int)_x.size(), axises);
        
        double distance = MAPST::distance(_t.begin(), _t.end(), _x.begin(), _y.begin(), _z.begin());
        double duration = _t.back() - _t[0];
        
        double area = MAPST::AREA(distance, duration) * self.calibratedAREAValue;
        double jerk = MAPST::JERK(_t.begin(), _t.end(), _x.begin(), _y.begin(), _z.begin()) * self.calibratedJERKValue;
        double rms = MAPST::RMS(_t.begin(), _t.end(), _x.begin(), _y.begin(), _z.begin()) * self.calibratedRMSValue;
        
        // Initialize RAW data string.
        UIDevice *device = [UIDevice currentDevice];
        NSString *clientSystemInfoString = [NSString stringWithFormat:@"%@ %@ %@ %@", device.name, device.model, device.systemName, device.systemVersion];
        NSString *rawDataString = [NSString stringWithFormat:@"%f;%f;%@;%@", area, rms, valuesString, clientSystemInfoString];
        
        // Initialize test session.
        MATestSession *testSession = [MATestSession new];
        testSession.creationDate = creatinDateString;
        testSession.score = @(jerk);
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
        _x.push_back(motion.userAcceleration.x * 9.81);
        _y.push_back(motion.userAcceleration.y * 9.81);
        _z.push_back(motion.userAcceleration.z * 9.81);
        _t.push_back(motion.timestamp);
    }
}

@end
