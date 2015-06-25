//
//  MATestSessionRawData.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionRawData.h"

@implementation MATestSessionRawData

#pragma mark -
#pragma mark Object Lifecycle

+ (instancetype)rawDataWithRawDataString:(NSString *)rawDataString
{
    return [[self alloc] initWithRawDataString:rawDataString];
}

- (instancetype)initWithRawDataString:(NSString *)rawDataString
{
    self = [super init];
    
    if (self != nil)
    {
        _rawDataString = [rawDataString copy];
        _rawDataComponents = [_rawDataString componentsSeparatedByString:@";"];
        
        switch ([_rawDataComponents count])
        {
            case 1:
            {
                _clientSystemInfo = _rawDataComponents[0];
                
                break;
            }
            case 4:
            {
                _area = _rawDataComponents[0];
                _rms = _rawDataComponents[1];
                _values = [_rawDataComponents[2] componentsSeparatedByString:@","];
                _clientSystemInfo = _rawDataComponents[3];
                
                break;
            }
            default:
                break;
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark Methods

- (NSUInteger)valueCount
{
    return [self.values count] / 4;
}

- (void)getXValue:(NSString *__autoreleasing *)xValue
           yValue:(NSString *__autoreleasing *)yValue
           zValue:(NSString *__autoreleasing *)zValue
           tValue:(NSString *__autoreleasing *)tValue
          atIndex:(NSUInteger)index
{
    NSUInteger valueIndex = index * 4 + 1; // The first value is reserved.
    
    if (xValue != NULL)
    {
        *xValue = self.values[valueIndex + 0];
    }
    
    if (yValue != NULL)
    {
        *yValue = self.values[valueIndex + 1];
    }
    
    if (zValue != NULL)
    {
        *zValue = self.values[valueIndex + 2];
    }
    
    if (tValue != NULL)
    {
        *tValue = self.values[valueIndex + 3];
    }
}

@end
