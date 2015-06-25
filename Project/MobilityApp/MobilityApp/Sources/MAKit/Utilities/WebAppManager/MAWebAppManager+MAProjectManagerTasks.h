//
//  MAWebAppManager+MAProjectManagerTasks.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager.h"

@class MAProjectsWebAppResponse;

@interface MAWebAppManager (MAProjectManagerTasks)

// 1. Get project info list.
- (NSURLSessionTask *)getProjectInfoListWithCompletionHandler:(void (^)(MAProjectsWebAppResponse *response, NSError *error))handler;

@end
