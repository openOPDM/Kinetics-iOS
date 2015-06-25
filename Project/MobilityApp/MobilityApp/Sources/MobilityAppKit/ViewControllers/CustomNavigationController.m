//
//  CustomNavigationController.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/6/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
