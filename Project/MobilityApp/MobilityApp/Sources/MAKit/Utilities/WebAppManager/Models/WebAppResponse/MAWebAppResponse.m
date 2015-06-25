//
//  MAWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAWebAppResponse.h"

#import "MAConstants.h"

@implementation MAWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        NSParameterAssert(dictionary == nil || [dictionary isKindOfClass:[NSDictionary class]]);
        
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *response = [MAWebAppResponse ma_object:dictionary[kMAWebAppParameterResponseKey] validatingUsingClass:[NSDictionary class]];
            NSDictionary *error = [MAWebAppResponse ma_object:response[kMAWebAppParameterErrorKey] validatingUsingClass:[NSDictionary class]];
            NSDictionary *function = [MAWebAppResponse ma_object:response[kMAWebAppParameterFunctionKey] validatingUsingClass:[NSDictionary class]];
            NSDictionary *data = [MAWebAppResponse ma_object:function[kMAWebAppParameterDataKey] validatingUsingClass:[NSDictionary class]];
            
            if (error != nil)
            {
                NSNumber *code = [MAWebAppResponse ma_object:error[kMAWebAppParameterCodeKey] validatingUsingClass:[NSNumber class]];
                NSString *description = [MAWebAppResponse ma_object:error[kMAWebAppParameterDescriptionKey] validatingUsingClass:[NSString class]];
                
                if (code != nil && description != nil)
                {
                    _error = [NSError errorWithDomain:kMAWebAppErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey: description}];
                }
            }
            
            _data = data;
        }
        else
        {
            self = nil;
        }
    }
    
    return self;
}

#pragma mark
#pragma mark Overridden Methods

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" { Data: %@; Error: %@ }", self.data, self.error];
}

@end

@implementation MAWebAppResponse (MAPrivateAdditions)

+ (id)ma_object:(id)anObject validatingUsingClass:(Class)aClass
{
    NSParameterAssert(aClass != Nil);
    NSAssert(anObject == nil || anObject == [NSNull null] || [anObject isKindOfClass:aClass],
             @"The object must be an instance of given class or an instance of any class that inherits from that class.");
    
    return [anObject isKindOfClass:aClass] ? anObject : nil;
}

@end
