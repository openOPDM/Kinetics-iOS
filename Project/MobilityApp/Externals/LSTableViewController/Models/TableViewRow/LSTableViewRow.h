//
//  LSTableViewRow.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/12/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <Foundation/Foundation.h>

// ********************************************************************************************************************************************************** //

@interface LSTableViewRow : NSObject

// Identity.
@property (nonatomic, readonly) NSString *reuseIdentifier;

// Content.
@property (nonatomic) UIImage *image;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, copy) NSString *detailLabelText;

// Selection style.
@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;

// Accessories.
@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) UIView *accessoryView;

// Height.
@property (nonatomic, copy) NSNumber *height;

// Action.
@property (nonatomic, copy) void(^didSelectBlock)(LSTableViewRow *row);
@property (nonatomic, copy) void(^valueChangedBlock)(LSTableViewRow *row);

// Misc.
@property (nonatomic, getter = isActivated) BOOL activated;
@property (nonatomic) LSTableViewRow *childRow;

@end
