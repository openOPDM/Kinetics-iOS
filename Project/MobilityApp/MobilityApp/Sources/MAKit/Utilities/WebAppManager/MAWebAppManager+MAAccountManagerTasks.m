//
//  MAWebAppManager+MAAccountManagerTasks.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager+MAAccountManagerTasks.h"

#import "MAMessageWebAppResponse.h"
#import "MAProjectsWebAppResponse.h"
#import "MASessionTokenWebAppResponse.h"
#import "MAUserWebAppResponse.h"

@implementation MAWebAppManager (MAAccountManagerTasks)

- (NSURLSessionTask *)loginWithEmail:(NSString *)email
                            passHash:(NSString *)passHash
                             project:(NSNumber *)project
                   completionHandler:(void (^)(MASessionTokenWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self loginParametersWithEmail:email passHash:passHash project:project];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MASessionTokenWebAppResponse *webAppResponse = [MASessionTokenWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)logoutWithSessionToken:(NSString *)sessionToken
                           completionHandler:(void (^)(MAMessageWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self logoutParametersWithSessionToken:sessionToken];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAMessageWebAppResponse *webAppResponse = [MAMessageWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)createUserWithEmail:(NSString *)email
                                firstName:(NSString *)firstName
                               secondName:(NSString *)secondName
                                 passHash:(NSString *)passHash
                                  project:(NSArray *)project
                        completionHandler:(void (^)(MAMessageWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self createUserParametersWithEmail:email firstName:firstName secondName:secondName passHash:passHash project:project];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAMessageWebAppResponse *webAppResponse = [MAMessageWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)confirmCreateAccountWithConfirmationCode:(NSString *)confirmationCode
                                                         email:(NSString *)email
                                             completionHandler:(void (^)(MAMessageWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self confirmCreateAccountParametersWithConfirmationCode:confirmationCode email:email];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAMessageWebAppResponse *webAppResponse = [MAMessageWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)getUserInfoWithSessionToken:(NSString *)sessionToken
                                completionHandler:(void (^)(MAUserWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self getUserInfoParametersWithSessionToken:sessionToken];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAUserWebAppResponse *webAppResponse = [MAUserWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)authenticateWithEmail:(NSString *)email
                                   passHash:(NSString *)passHash
                          completionHandler:(void (^)(MAProjectsWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self authenticateParametersWithEmail:email passHash:passHash];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAProjectsWebAppResponse *webAppResponse = [MAProjectsWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Helpers

- (NSDictionary *)loginParametersWithEmail:(NSString *)email passHash:(NSString *)passHash project:(NSNumber *)project
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterEmailValue, kMAWebAppParameterValueKey: email},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterPassHashValue, kMAWebAppParameterValueKey: passHash},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterProjectKey, kMAWebAppParameterValueKey: project}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodLogin arguments:arguments];
}

- (NSDictionary *)logoutParametersWithSessionToken:(NSString *)sessionToken
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterSessionTokenValue, kMAWebAppParameterValueKey: sessionToken}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodLogout arguments:arguments];
}

- (NSDictionary *)createUserParametersWithEmail:(NSString *)email
                                      firstName:(NSString *)firstName
                                     secondName:(NSString *)secondName
                                       passHash:(NSString *)passHash
                                        project:(NSArray *)project
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterEmailValue, kMAWebAppParameterValueKey: email},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterFirstNameKey, kMAWebAppParameterValueKey: firstName},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterSecondNameKey, kMAWebAppParameterValueKey: secondName},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterPassHashValue, kMAWebAppParameterValueKey: passHash},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterProjectKey, kMAWebAppParameterValueKey: project}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodCreateUser arguments:arguments];
}

- (NSDictionary *)confirmCreateAccountParametersWithConfirmationCode:(NSString *)confirmationCode
                                                               email:(NSString *)email
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterConfirmationCodeValue, kMAWebAppParameterValueKey: confirmationCode},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterEmailValue, kMAWebAppParameterValueKey: email}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodConfirmCreate arguments:arguments];
}

- (NSDictionary *)getUserInfoParametersWithSessionToken:(NSString *)sessionToken
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterSessionTokenValue, kMAWebAppParameterValueKey: sessionToken}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodGetUserInfo arguments:arguments];
}

- (NSDictionary *)authenticateParametersWithEmail:(NSString *)email passHash:(NSString *)passHash
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterEmailValue, kMAWebAppParameterValueKey: email},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterPassHashValue, kMAWebAppParameterValueKey: passHash}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetAccountManager method:kMAWebAppMethodAuthenticate arguments:arguments];
}

@end
