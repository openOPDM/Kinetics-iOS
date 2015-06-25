//
//  NSDateFormatter+MAAdditions.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MAAdditions)

+ (NSString*)ma_stringFromTimeInterval:(NSTimeInterval)timeInterval;

@end
