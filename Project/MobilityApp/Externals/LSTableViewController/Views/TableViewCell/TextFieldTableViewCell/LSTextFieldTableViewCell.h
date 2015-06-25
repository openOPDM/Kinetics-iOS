//
//  LSTextFieldTableViewCell.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/10/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewCell.h"

// ********************************************************************************************************************************************************** //

extern NSString * const kLSTextFieldTableViewCellID;

// ********************************************************************************************************************************************************** //

@interface LSTextFieldTableViewCell : LSTableViewCell <UITextFieldDelegate>

@property (nonatomic, readonly) UITextField *textField;

@end
