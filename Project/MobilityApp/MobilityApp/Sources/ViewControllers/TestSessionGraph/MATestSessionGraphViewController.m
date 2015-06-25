//
//  MATestSessionGraphViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/20/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionGraphViewController.h"

#import "APLGraphView.h"

#import "MATestSessionRawData.h"

@implementation MATestSessionGraphViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.graphView drowStabilogramWitharray:self.testRawData.values];
}

@end
