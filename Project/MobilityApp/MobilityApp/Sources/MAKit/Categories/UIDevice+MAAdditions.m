//
//  UIDevice+MAAdditions.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/13/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "UIDevice+MAAdditions.h"

#include <sys/utsname.h>

@implementation UIDevice (MAAdditions)

#pragma mark -
#pragma mark Methods

- (NSString *)ma_certifiedDevices
{
    return @"iPhone 4, 4S, 5, 5S, iPod touch (5th generation)";
}

- (BOOL)isMa_certified
{
    return [[self ma_certifiedMachines] containsObject:[self ma_machine]];
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)ma_machine
{
    NSString *machine = nil;
    struct utsname systemName;
    
    if (uname(&systemName) == 0)
    {
        machine = [NSString stringWithCString:systemName.machine encoding:NSUTF8StringEncoding];
    }
    
    return machine;
}

- (NSArray *)ma_certifiedMachines
{
    static NSArray *certifiedMachines = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
    {
        certifiedMachines = @[@"iPhone3,1", @"iPhone3,2", @"iPhone3,3",
                              @"iPhone4,1",
                              @"iPhone5,1", @"iPhone5,2",
                              @"iPhone6,1", @"iPhone6,2",
                              @"iPod5,1"];
    });
    
    return certifiedMachines;
}

@end
