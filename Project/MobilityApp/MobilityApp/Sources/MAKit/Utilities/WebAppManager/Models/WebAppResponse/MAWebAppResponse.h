//
//  MAWebAppResponse.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAWebAppResponse : NSObject

@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSDictionary *data;

+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface MAWebAppResponse (MAPrivateAdditions)

/**
 Convenience method for object validation using Class.
 @param anObject The object to be validated.
 @param aClass A class object representing the Objective-C class to be tested. This value must not be Nil.
 @return Validated object or nil.
 */
+ (id)ma_object:(id)anObject validatingUsingClass:(Class)aClass;

@end
