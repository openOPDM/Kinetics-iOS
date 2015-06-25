//
//  NSDateFormatter+MAAdditions.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "NSDateFormatter+MAAdditions.h"

@implementation NSDateFormatter (MAAdditions)

+ (NSString *)ma_stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    });
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
    
    return [dateFormatter stringFromDate:date];
}

@end
