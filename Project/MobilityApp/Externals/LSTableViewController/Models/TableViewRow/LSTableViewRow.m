//
//  LSTableViewRow.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/12/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewRow.h"

#import "LSTableViewCell.h"

// ********************************************************************************************************************************************************** //

@implementation LSTableViewRow

#pragma mark -
#pragma mark Accessors

- (NSString *)reuseIdentifier
{
    return kLSTableViewCellID;
}

@end
