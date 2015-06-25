//
//  MAWebAppManager+MAProjectManagerTasks.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager+MAProjectManagerTasks.h"

#import "MAProjectsWebAppResponse.h"

@implementation MAWebAppManager (MAProjectManagerTasks)

- (NSURLSessionTask *)getProjectInfoListWithCompletionHandler:(void (^)(MAProjectsWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self getProjectInfoListParameters];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAProjectsWebAppResponse *webAppResponse = [MAProjectsWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Helpers

- (NSDictionary*)getProjectInfoListParameters
{
    NSArray *arguments = @[];
    
    return [self requestParametersWithTarget:kMAWebAppTargetProjectManager method:kMAWebAppMethodGetProjectInfoList arguments:arguments];
}

@end
