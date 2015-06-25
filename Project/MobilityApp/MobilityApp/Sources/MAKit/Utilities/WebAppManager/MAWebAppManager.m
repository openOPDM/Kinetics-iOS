//
//  MAWebAppManager.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppManager.h"

#import "MAMacro.h"

#import "AFNetworking.h"

#import "UIKit+AFNetworking.h"

@interface MAWebAppManager ()

@property (nonatomic, readonly) AFHTTPSessionManager *webAppHTTPSessionManager;

@end

@implementation MAWebAppManager

#pragma mark -
#pragma mark Singleton

MA_SINGLETON_SYNTHESIZE(MAWebAppManager, sharedManager);

#pragma mark -
#pragma mark Object Lifecycle

- (in)init
{
    self = [super init];
    
    if (self != nil)
    {
        NSURLCache *sharedURLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedURLCache];
        
        NSURL *baseURL = [NSURL URLWithString:kMAWebAppBaseURL];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = kMATimeoutIntervalForRequest;
        
        _webAppHTTPSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:sessionConfiguration];
        _webAppHTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _webAppHTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [_webAppHTTPSessionManager.reachabilityManager startMonitoring];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [_webAppHTTPSessionManager.reachabilityManager stopMonitoring];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = NO;
}

#pragma mark -
#pragma mark Methods

- (NSURLSessionDataTask *)sendRequestWithParameters:(NSDictionary *)parameters completionHandler:(void (^)(NSDictionary *, NSError *))handler
{
    if (handler == nil)
    {
        return nil;
    }
    
    void (^success)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject)
    {
        handler(responseObject, nil);
    };
    
    void (^failure)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error)
    {
        handler(nil, error);
    };
    
    return [self.webAppHTTPSessionManager POST:@"" parameters:parameters success:success failure:failure];
}

- (NSDictionary *)requestParametersWithTarget:(NSString *)target method:(NSString *)method arguments:(NSArray *)arguments
{
    NSDictionary *functionParameters = @{kMAWebAppParameterMethodKey: method,
                                         kMAWebAppParameterTimestampKey: @0,
                                         kMAWebAppParameterTargetKey: target,
                                         kMAWebAppParameterArgumentsKey: arguments};
    NSDictionary *requestParameters = @{kMAWebAppParameterFunctionKey: functionParameters};
    NSDictionary *parameters = @{kMAWebAppParameterRequestKey: requestParameters};
    
    return parameters;
}

- (BOOL)isReachable
{
    return [self.webAppHTTPSessionManager.reachabilityManager isReachable];
}

@end
