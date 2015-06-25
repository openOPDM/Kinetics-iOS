//
//  MATestSessionGraphViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/20/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APLGraphView;
@class MATestSessionRawData;

@interface MATestSessionGraphViewController : UIViewController

@property (nonatomic) IBOutlet APLGraphView *graphView;

@property (nonatomic) MATestSessionRawData *testRawData;

@end
