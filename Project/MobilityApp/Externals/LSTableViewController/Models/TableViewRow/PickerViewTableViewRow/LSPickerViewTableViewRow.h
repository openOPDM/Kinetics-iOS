//
//  LSPickerViewTableViewRow.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewRow.h"

// ********************************************************************************************************************************************************** //

@interface LSPickerViewTableViewRow : LSTableViewRow

@property (nonatomic, copy) NSArray *dataSource; // Array of LSPickerViewSection objects.

- (void)selectRow:(NSUInteger)row inComponent:(NSUInteger)component;
- (NSUInteger)selectedRowInComponent:(NSInteger)component;

@end
