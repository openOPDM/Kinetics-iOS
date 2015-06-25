//
//  MAPSTSessionManager.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionManager.h"

extern const NSTimeInterval kMAPSTSessionDuration;

@interface MAPSTSessionManager : MATestSessionManager

@property (nonatomic) double calibratedAREAValue;
@property (nonatomic) double calibratedJERKValue;
@property (nonatomic) double calibratedRMSValue;

- (void)resetCalibratedValues;

@end
