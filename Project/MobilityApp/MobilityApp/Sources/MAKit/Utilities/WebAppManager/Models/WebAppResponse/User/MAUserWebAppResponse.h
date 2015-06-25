//
//  MAUserWebAppResponse.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppResponse.h"

@class MAUser;

@interface MAUserWebAppResponse : MAWebAppResponse

@property (nonatomic, readonly) MAUser *user;

@end
