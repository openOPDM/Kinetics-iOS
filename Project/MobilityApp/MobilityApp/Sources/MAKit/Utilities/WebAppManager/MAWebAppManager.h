//
//  MAWebAppManager.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAWebAppManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)sendRequestWithParameters:(NSDictionary *)parameters completionHandler:(void (^)(NSDictionary *response, NSError *error))handler;
- (NSDictionary *)requestParametersWithTarget:(NSString *)target method:(NSString *)method arguments:(NSArray *)arguments;

- (BOOL)isReachable;

@end
