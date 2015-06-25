//
//  MATestSessionWebAppResponse.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppResponse.h"

@class MATestSession;

@interface MATestSessionWebAppResponse : MAWebAppResponse

@property (nonatomic, readonly) MATestSession *testSession;

@end
