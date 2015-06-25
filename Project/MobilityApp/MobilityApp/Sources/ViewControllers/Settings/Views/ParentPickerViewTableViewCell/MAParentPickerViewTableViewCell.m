//
//  MAParentPickerViewTableViewCell.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAParentPickerViewTableViewCell.h"

#import "LSPickerViewComponent.h"
#import "LSPickerViewRow.h"
#import "LSPickerViewTableViewRow.h"
#import "MAParentPickerViewTableViewRow.h"

NSString * const kMAParentPickerViewTableViewCellIdentifier = @"MAParentPickerViewCell";

@interface MAParentPickerViewTableViewCell ()

@property (nonatomic, readonly) UIColor *defaultDetailsLabelTextColor;
@property (nonatomic, readonly) MAParentPickerViewTableViewRow *parentPickerViewTableViewRow;

@end

@implementation MAParentPickerViewTableViewCell

#pragma mark -
#pragma mark Object Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
    {
        _defaultDetailsLabelTextColor = self.detailTextLabel.textColor;
    }
    
    return self;
}

#pragma mark -
#pragma mark Overridden Accessors

- (void)setRow:(LSTableViewRow *)row
{
    [super setRow:row];
    [self updateDetailsLabelText];
    [self updateDetailsLabelTextColor];
    
    NSParameterAssert(row == nil || [row.childRow isKindOfClass:[LSPickerViewTableViewRow class]]);
    
    if ([row.childRow isKindOfClass:[LSPickerViewTableViewRow class]])
    {
        __weak __typeof(self) weakSelf = self;
        
        row.childRow.valueChangedBlock = ^(LSTableViewRow *childRow)
        {
            [weakSelf updateDetailsLabelText];
            
            if (weakSelf.row.valueChangedBlock != nil)
            {
                weakSelf.row.valueChangedBlock(childRow);
            }
        };
    }
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)canBecomeActive
{
    return YES;
}

- (void)didActivate
{
    [super didActivate];
    
    [self updateDetailsLabelTextColor];
}

- (void)didDeactivate
{
    [super didDeactivate];
    
    [self updateDetailsLabelTextColor];
}

#pragma mark -
#pragma mark Private Accessors

- (MAParentPickerViewTableViewRow *)parentPickerViewTableViewRow
{
    NSAssert(self.row == nil || [self.row isKindOfClass:[MAParentPickerViewTableViewRow class]], @"Wrong type of row");
    return (MAParentPickerViewTableViewRow *)self.row;
}

#pragma mark -
#pragma mark Helpers

- (void)updateDetailsLabelText
{
    LSPickerViewTableViewRow *childPickerViewTableViewRow = (LSPickerViewTableViewRow *)self.parentPickerViewTableViewRow.childRow;
    
    NSUInteger componentsIndex = 0;
    NSUInteger rowIndex = [childPickerViewTableViewRow selectedRowInComponent:componentsIndex];
    
    LSPickerViewComponent *pickerViewComponent = childPickerViewTableViewRow.dataSource[componentsIndex];
    LSPickerViewRow *pickerViewRow = pickerViewComponent.rows[rowIndex];
    
    self.row.detailLabelText = pickerViewRow.title;
    self.detailTextLabel.text = pickerViewRow.title;
}

- (void)updateDetailsLabelTextColor
{
    if ([self.parentPickerViewTableViewRow isActivated])
    {
        self.detailTextLabel.textColor = self.parentPickerViewTableViewRow.activatedDetailLabelTextColor != nil
        ? self.parentPickerViewTableViewRow.activatedDetailLabelTextColor
        : self.defaultDetailsLabelTextColor;
    }
    else
    {
        self.detailTextLabel.textColor = self.parentPickerViewTableViewRow.detailLabelTextColor != nil
        ? self.parentPickerViewTableViewRow.detailLabelTextColor
        : self.defaultDetailsLabelTextColor;
    }
}

@end
