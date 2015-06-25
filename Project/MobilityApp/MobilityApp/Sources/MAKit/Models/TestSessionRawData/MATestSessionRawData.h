//
//  MATestSessionRawData.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MATestSessionRawData : NSObject

+ (instancetype)rawDataWithRawDataString:(NSString *)rawDataString;
- (instancetype)initWithRawDataString:(NSString *)rawDataString;

@property (nonatomic, readonly) NSString *rawDataString;
@property (nonatomic, readonly) NSArray *rawDataComponents;

@property (nonatomic, readonly) NSString *area;
@property (nonatomic, readonly) NSString *rms;
@property (nonatomic, readonly) NSArray *values;
@property (nonatomic, readonly) NSString *clientSystemInfo;

- (NSUInteger)valueCount;
- (void)getXValue:(NSString **)xValue yValue:(NSString **)yValue zValue:(NSString **)zValue tValue:(NSString **)tValue atIndex:(NSUInteger)index;

@end
