//
//  MASessionTokenWebAppResponse.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppResponse.h"

@interface MASessionTokenWebAppResponse : MAWebAppResponse

@property (nonatomic, readonly) NSString *sessionToken;

@end
