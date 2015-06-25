//
//  LSTextFieldTableViewRow.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTextFieldTableViewRow.h"

#import "LSTextFieldTableViewCell.h"

// ********************************************************************************************************************************************************** //

@implementation LSTextFieldTableViewRow

#pragma mark -
#pragma mark Overridden Accessors

- (NSString *)reuseIdentifier
{
    return kLSTextFieldTableViewCellID;
}

@end
