//
//  LSSwitchTableViewRow.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewRow.h"

// ********************************************************************************************************************************************************** //

@class LSSwitchTableViewCell;

// ********************************************************************************************************************************************************** //

@interface LSSwitchTableViewRow : LSTableViewRow

@property (nonatomic, getter = isOn) BOOL on;

@end
