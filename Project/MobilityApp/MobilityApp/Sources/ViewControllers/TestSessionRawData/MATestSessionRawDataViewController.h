//
//  MATestSessionRawDataViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>

@class MATestSessionRawData;

@interface MATestSessionRawDataViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic) MATestSessionRawData *testRawData;

- (IBAction)mail:(id)sender;

@end
