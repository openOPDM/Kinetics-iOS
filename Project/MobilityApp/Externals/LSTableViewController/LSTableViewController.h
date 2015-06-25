//
//  LSTableViewController.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/11/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <UIKit/UIKit.h>

// ********************************************************************************************************************************************************** //

@interface LSTableViewController : UITableViewController

@property (nonatomic) NSArray *dataSource; // Array of LKDSectionModel objects.

- (NSIndexPath *)indexPathForActiveRow;

@end
