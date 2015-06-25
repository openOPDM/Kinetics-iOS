//
//  MATestSessionReportViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MASyncing.h"

@class MANotesTableViewCell;
@class TestData;

@interface MATestSessionReportViewController : UITableViewController <MASyncing>

@property (nonatomic) UITableViewCell *testDateTableViewCell;
@property (nonatomic) UITableViewCell *testIsValidTableViewCell;
@property (nonatomic) UITableViewCell *testGraphTableViewCell;
@property (nonatomic) UITableViewCell *testRawDataTableViewCell;
@property (nonatomic) MANotesTableViewCell *testNotesTableViewCell;

@property (nonatomic) UITableViewCell *testPSTJERKTableViewCell;
@property (nonatomic) UITableViewCell *testPSTAREATableViewCell;
@property (nonatomic) UITableViewCell *testPSTRMSTableViewCell;

@property (nonatomic) UITableViewCell *testTUGDurationTableViewCell;

@property (nonatomic) TestData *testData;

@end
