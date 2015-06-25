//
//  MAUserSettings.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAUserSettings : NSObject

@property (nonatomic) double syncRate;
@property (nonatomic) double updateRate;
@property (nonatomic) BOOL vibrate;

+ (instancetype)sharedUserSettings;
+ (void)resetSharedUserSettings;

- (void)startSync;
- (void)stopSync;

@end
