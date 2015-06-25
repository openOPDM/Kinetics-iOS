//
//  LSSwitchTableViewRow.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSSwitchTableViewRow.h"

#import "LSSwitchTableViewCell.h"

// ********************************************************************************************************************************************************** //

@implementation LSSwitchTableViewRow

#pragma mark -
#pragma mark Overridden Accessors

- (NSString *)reuseIdentifier
{
    return kLSSwitchTableViewCellID;
}

@end
