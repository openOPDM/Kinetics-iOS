//
//  LSTextFieldTableViewRow.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewRow.h"

// ********************************************************************************************************************************************************** //

@interface LSTextFieldTableViewRow : LSTableViewRow

@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic) UIKeyboardType keyboardType;

@end
