//
//  MAWebAppManager+MATestSessionManagerTasks.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager.h"

@class MAMessageWebAppResponse;
@class MATestSession;
@class MATestSessionWebAppResponse;

@interface MAWebAppManager (MATestSessionManagerTasks)

// 1. Add test session.
- (NSURLSessionTask *)addTestSessionWithSessionToken:(NSString *)sessionToken
                                         testSession:(MATestSession *)testSession
                                   completionHandler:(void (^)(MAMessageWebAppResponse *response, NSError *error))handler;

// 4. Get test session details.
- (NSURLSessionTask *)getTestSessionDetailsWithSessionToken:(NSString *)sessionToken
                                                 identifier:(NSNumber *)identifier
                                completionHandler:(void (^)(MATestSessionWebAppResponse *response, NSError *error))handler;

@end
