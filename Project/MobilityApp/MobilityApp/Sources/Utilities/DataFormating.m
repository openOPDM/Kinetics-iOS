//
//  DataFormating.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/6/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "DataFormating.h"

@implementation DataFormating

+ (NSString*)formatedDate:(NSTimeInterval)aDate{
    
    NSDate* theDate = [[NSDate alloc]initWithTimeIntervalSince1970:(aDate/1000)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:theDate];
    
    return dateString;
    
}

@end
