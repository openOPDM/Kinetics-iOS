//
//  LSSwitchTableViewCell.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/10/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewCell.h"

// ********************************************************************************************************************************************************** //

extern NSString * const kLSSwitchTableViewCellID;

// ********************************************************************************************************************************************************** //

@interface LSSwitchTableViewCell : LSTableViewCell

@property (nonatomic, readonly) UISwitch *switchControl;

@end
