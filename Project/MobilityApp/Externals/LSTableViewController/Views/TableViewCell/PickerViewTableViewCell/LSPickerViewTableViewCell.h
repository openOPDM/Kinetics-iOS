//
//  LSPickerViewTableViewCell.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/11/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewCell.h"

// ********************************************************************************************************************************************************** //

extern NSString * const kLSPickerViewTableViewCellID;

// ********************************************************************************************************************************************************** //

@interface LSPickerViewTableViewCell : LSTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readonly) UIPickerView *pickerView;

+ (CGFloat)height;

@end
