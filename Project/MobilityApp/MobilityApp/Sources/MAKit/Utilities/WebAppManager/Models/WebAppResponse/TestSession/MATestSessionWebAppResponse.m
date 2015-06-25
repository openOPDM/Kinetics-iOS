//
//  MATestSessionWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionWebAppResponse.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"

@implementation MATestSessionWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self != nil)
    {
        NSDictionary *testDictionary = [MAWebAppResponse ma_object:self.data[kMAWebAppParameterTestSessionKey] validatingUsingClass:[NSDictionary class]];
        
        if (testDictionary != nil)
        {
            _testSession = [MATestSession new];
            _testSession.identifier = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterIDKey] validatingUsingClass:[NSNumber class]];
            _testSession.creationDate = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterCreationDateKey] validatingUsingClass:[NSString class]];
            _testSession.type = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterTypeKey] validatingUsingClass:[NSString class]];
            _testSession.score = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterScoreKey] validatingUsingClass:[NSNumber class]];
            _testSession.isValid = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterIsValidKey] validatingUsingClass:[NSNumber class]];
            _testSession.extension = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterExtensionKey] validatingUsingClass:[NSArray class]];
            
            NSString *rawData = [MAWebAppResponse ma_object:testDictionary[kMAWebAppParameterRawDataKey] validatingUsingClass:[NSString class]];
            
            if (rawData != nil)
            {
                _testSession.rawData = [[MATestSessionRawData alloc] initWithRawDataString:rawData];
            }
        }
    }
    
    return self;
}

@end
