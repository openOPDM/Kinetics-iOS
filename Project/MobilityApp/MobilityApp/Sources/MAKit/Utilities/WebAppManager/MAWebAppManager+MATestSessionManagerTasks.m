//
//  MAWebAppManager+MATestSessionManagerTasks.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager+MATestSessionManagerTasks.h"

#import "MAMessageWebAppResponse.h"
#import "MATestSession.h"
#import "MATestSessionRawData.h"
#import "MATestSessionWebAppResponse.h"

@implementation MAWebAppManager (MATestSessionManagerTasks)

- (NSURLSessionTask *)addTestSessionWithSessionToken:(NSString *)sessionToken
                                         testSession:(MATestSession *)testSession
                                   completionHandler:(void (^)(MAMessageWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self addTestSessionParametersWithSessionToken:sessionToken testSession:testSession];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MAMessageWebAppResponse *webAppResponse = [MAMessageWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

- (NSURLSessionTask *)getTestSessionDetailsWithSessionToken:(NSString *)sessionToken
                                                 identifier:(NSNumber *)identifier
                                          completionHandler:(void (^)(MATestSessionWebAppResponse *, NSError *))handler
{
    if (handler == nil) { return nil; }
    
    NSDictionary *parameters = [self getTestSessionDetailsParametersWithSessionToken:sessionToken identifier:identifier];
    void (^completionHandler)(NSDictionary *response, NSError *error) = ^(NSDictionary *response, NSError *error)
    {
        MATestSessionWebAppResponse *webAppResponse = [MATestSessionWebAppResponse responseWithDictionary:response];
        handler(webAppResponse, error);
    };
    
    return [self sendRequestWithParameters:parameters completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Helpers

- (NSDictionary *)addTestSessionParametersWithSessionToken:(NSString *)sessionToken testSession:(MATestSession *)testSession
{
    NSDictionary *testSessionArguments = @{kMAWebAppParameterTypeKey: testSession.type,
                                           kMAWebAppParameterRawDataKey: testSession.rawData.rawDataString,
                                           kMAWebAppParameterScoreKey: testSession.score,
                                           kMAWebAppParameterIsValidKey: testSession.isValid,
                                           kMAWebAppParameterExtensionKey: testSession.extension};
    
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterSessionTokenValue, kMAWebAppParameterValueKey: sessionToken},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterTestSessionValue, kMAWebAppParameterValueKey: testSessionArguments}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetTestSessionManager method:kMAWebAppMethodAdd arguments:arguments];
}

- (NSDictionary *)getTestSessionDetailsParametersWithSessionToken:(NSString *)sessionToken identifier:(NSNumber *)identifier
{
    NSArray *arguments = @[@{kMAWebAppParameterNameKey: kMAWebAppParameterSessionTokenValue, kMAWebAppParameterValueKey: sessionToken},
                           @{kMAWebAppParameterNameKey: kMAWebAppParameterIDValue, kMAWebAppParameterValueKey: identifier}];
    
    return [self requestParametersWithTarget:kMAWebAppTargetTestSessionManager method:kMAWebAppMethodGetDetails arguments:arguments];
}

@end
