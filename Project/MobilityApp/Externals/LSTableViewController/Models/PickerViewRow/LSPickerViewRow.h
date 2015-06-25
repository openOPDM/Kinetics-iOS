//
//  LSPickerViewRow.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <Foundation/Foundation.h>

// ********************************************************************************************************************************************************** //

@interface LSPickerViewRow : NSObject

// Content.
@property (nonatomic, copy) NSString *title;

@property (nonatomic) id value;

@end
