//
//  LSPickerViewTableViewRow.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSPickerViewTableViewRow.h"

#import "LSPickerViewTableViewCell.h"

// ********************************************************************************************************************************************************** //

@interface LSPickerViewTableViewRow ()

@property (nonatomic) NSMutableArray *selectedRows;

@end

// ********************************************************************************************************************************************************** //

@implementation LSPickerViewTableViewRow

#pragma mark -
#pragma mark Overridden Accessors

- (NSString *)reuseIdentifier
{
    return kLSPickerViewTableViewCellID;
}

- (NSNumber *)height
{
    return @([LSPickerViewTableViewCell height]);
}

#pragma mark -
#pragma mark Accessors

- (void)setDataSource:(NSArray *)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = [dataSource copy];
        
        self.selectedRows = nil;
    }
}

#pragma mark -
#pragma mark Methods

- (void)selectRow:(NSUInteger)row inComponent:(NSUInteger)component
{
    self.selectedRows[component] = @(row);
}

- (NSUInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.selectedRows[component] unsignedIntegerValue];
}

#pragma mark -
#pragma mark Private Accessors

- (NSMutableArray *)selectedRows
{
    if (_selectedRows == nil)
    {
        _selectedRows = [NSMutableArray arrayWithCapacity:[self.dataSource count]];
        
        for (NSUInteger index = 0; index < [self.dataSource count]; index++)
        {
            [_selectedRows addObject:@0];
        }
    }
    
    return _selectedRows;
}

@end
