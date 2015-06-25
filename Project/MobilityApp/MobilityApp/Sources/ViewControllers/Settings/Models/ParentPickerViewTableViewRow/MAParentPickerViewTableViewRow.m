//
//  MAParentPickerViewTableViewRow.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAParentPickerViewTableViewRow.h"

#import "MAParentPickerViewTableViewCell.h"

@implementation MAParentPickerViewTableViewRow

#pragma mark -
#pragma mark Overridden Accessors

- (NSString *)reuseIdentifier
{
    return kMAParentPickerViewTableViewCellIdentifier;
}

@end
