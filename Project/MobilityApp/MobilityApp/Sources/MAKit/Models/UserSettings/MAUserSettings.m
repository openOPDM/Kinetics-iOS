//
//  MAUserSettings.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAUserSettings.h"

#import "MAConstants.h"

#import "TestDataManager.h"

static MAUserSettings *sMASharedUserSettings;

@implementation MAUserSettings

#pragma mark -
#pragma mark Class Methods

+ (instancetype)sharedUserSettings
{
    if (sMASharedUserSettings == nil)
    {
        sMASharedUserSettings = [MAUserSettings new];
        [sMASharedUserSettings load];
    }
    
    return sMASharedUserSettings;
}

+ (void)resetSharedUserSettings
{
    [sMASharedUserSettings reset];
}

#pragma mark -
#pragma mark Accessors

- (void)setSyncRate:(double)syncRate
{
    if (_syncRate != syncRate)
    {
        _syncRate = syncRate;
        
        [self setNeedsSave];
    }
}

- (void)setUpdateRate:(double)updateRate
{
    if (_updateRate != updateRate)
    {
        _updateRate = updateRate;
        
        [self setNeedsSave];
    }
}

- (void)setVibrate:(BOOL)vibrate
{
    if (_vibrate != vibrate)
    {
        _vibrate = vibrate;
        
        [self setNeedsSave];
    }
}

#pragma mark -
#pragma mark Methods

- (void)startSync
{
    [self stopSync];
    
    if (self.syncRate > 0.0)
    {
        [[TestDataManager sharedInstance] syncWithTimer:self.syncRate];
    }
}

- (void)stopSync
{
    [[TestDataManager sharedInstance] stopTimer];
}

#pragma mark -
#pragma mark Private Methods

- (void)load
{
    if (self == sMASharedUserSettings)
    {
        NSDictionary *userSettingsInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kMAUserDefaultsUserSettingsKey];
        
        if (userSettingsInfo == nil)
        {
            [self reset];
        }
        else
        {
            _syncRate = [userSettingsInfo[kMAUserDefaultsSyncRateKey] doubleValue];
            _updateRate = [userSettingsInfo[kMAUserDefaultsUpdateRateKey] doubleValue];
            _vibrate = [userSettingsInfo[kMAUserDefaultsVibrateKey] boolValue];
        }
    }
}

- (void)save
{
    if (self == sMASharedUserSettings)
    {
        NSMutableDictionary *userSettingsInfo = [NSMutableDictionary dictionary];
        userSettingsInfo[kMAUserDefaultsSyncRateKey] = @(_syncRate);
        userSettingsInfo[kMAUserDefaultsUpdateRateKey] = @(_updateRate);
        userSettingsInfo[kMAUserDefaultsVibrateKey] = @(_vibrate);
        
        [[NSUserDefaults standardUserDefaults] setObject:userSettingsInfo forKey:kMAUserDefaultsUserSettingsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)reset
{
    if (self == sMASharedUserSettings)
    {
        _syncRate = 1.0;
        _updateRate = 0.01;
        _vibrate = YES;
        
        [self save];
    }
}

#pragma mark -
#pragma mark Helpers

- (void)setNeedsSave
{
    if (self == sMASharedUserSettings)
    {
        SEL selector = @selector(save);
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
        [self performSelector:selector withObject:nil afterDelay:0.25];
    }
}

@end
