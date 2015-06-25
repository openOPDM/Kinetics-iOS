//
//  MACalibrateViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MACalibrateViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) IBOutlet UITableViewCell *calibrateTableViewCell;
@property (nonatomic) IBOutlet UITableViewCell *resetCalibraionTableViewCell;

- (IBAction)calibrate:(id)sender;
- (IBAction)reset:(id)sender;

@end
