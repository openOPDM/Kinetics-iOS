//
//  MATestRoomViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/13/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MASyncing.h"

@interface MATestRoomViewController : UITableViewController <MASyncing>

- (IBAction)signOut:(id)sender;
- (IBAction)refresh:(id)sender;

@end
