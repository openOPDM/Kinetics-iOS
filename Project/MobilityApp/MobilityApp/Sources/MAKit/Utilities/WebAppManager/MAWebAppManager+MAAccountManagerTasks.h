//
//  MAWebAppManager+MAAccountManagerTasks.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager.h"

@class MAMessageWebAppResponse;
@class MAProjectsWebAppResponse;
@class MASessionTokenWebAppResponse;
@class MAUserWebAppResponse;

@interface MAWebAppManager (MAAccountManagerTasks)

// 1. Login.
- (NSURLSessionTask *)loginWithEmail:(NSString *)email
                            passHash:(NSString *)passHash
                             project:(NSNumber *)project
                   completionHandler:(void (^)(MASessionTokenWebAppResponse *response, NSError *error))handler;

// 2. Logout.
- (NSURLSessionTask *)logoutWithSessionToken:(NSString *)sessionToken
                           completionHandler:(void (^)(MAMessageWebAppResponse *response, NSError *error))handler;

// 3. Create user.
- (NSURLSessionTask *)createUserWithEmail:(NSString *)email
                                firstName:(NSString *)firstName
                               secondName:(NSString *)secondName
                                 passHash:(NSString *)passHash
                                  project:(NSArray *)project
                        completionHandler:(void (^)(MAMessageWebAppResponse *response, NSError *error))handler;

// 5. Confirm create account.
- (NSURLSessionTask *)confirmCreateAccountWithConfirmationCode:(NSString *)confirmationCode
                                                         email:(NSString *)email
                                             completionHandler:(void (^)(MAMessageWebAppResponse *response, NSError *error))handler;

// 7. Get user info.
- (NSURLSessionTask *)getUserInfoWithSessionToken:(NSString *)sessionToken
                                completionHandler:(void (^)(MAUserWebAppResponse *response, NSError *error))handler;

// 35. Authenticate.
- (NSURLSessionTask *)authenticateWithEmail:(NSString *)email
                                   passHash:(NSString *)passHash
                          completionHandler:(void (^)(MAProjectsWebAppResponse *response, NSError *error))handler;

@end
