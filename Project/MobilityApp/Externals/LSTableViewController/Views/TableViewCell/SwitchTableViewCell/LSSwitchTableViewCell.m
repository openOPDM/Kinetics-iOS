//
//  LSSwitchTableViewCell.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/10/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSSwitchTableViewCell.h"

#import "LSSwitchTableViewRow.h"

// ********************************************************************************************************************************************************** //

NSString * const kLSSwitchTableViewCellID = @"LSSwitchCell";

// ********************************************************************************************************************************************************** //

@interface LSSwitchTableViewCell ()

@property (nonatomic, readonly) LSSwitchTableViewRow *switchTableViewRow;

@end

// ********************************************************************************************************************************************************** //

@implementation LSSwitchTableViewCell

#pragma mark -
#pragma mark Overridden Accessors

- (void)setRow:(LSTableViewRow *)row
{
    [super setRow:row];
    
    self.switchControl.on = [self.switchTableViewRow isOn];
}

#pragma mark -
#pragma mark Accessors

- (UISwitch *)switchControl
{
    if (![self.accessoryView isKindOfClass:[UISwitch class]])
    {
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchControl.on = [self.switchTableViewRow isOn];
        [switchControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.accessoryView = switchControl;
    }
    
    return (UISwitch *)self.accessoryView;
}

#pragma mark -
#pragma mark Private Accessors

- (LSSwitchTableViewRow *)switchTableViewRow
{
    NSAssert(self.row == nil || [self.row isKindOfClass:[LSSwitchTableViewRow class]], @"Wrong type of row");
    return (LSSwitchTableViewRow *)self.row;
}

#pragma mark -
#pragma mark Private Actions

- (void)valueChanged:(id)sender
{
    self.switchTableViewRow.on = [sender isOn];
    
    if (self.switchTableViewRow.valueChangedBlock != nil)
    {
        self.switchTableViewRow.valueChangedBlock(self.switchTableViewRow);
    }
}

@end
