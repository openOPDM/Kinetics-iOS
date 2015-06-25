//
//  LSTableViewCell.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <UIKit/UIKit.h>

// ********************************************************************************************************************************************************** //

@class LSTableViewRow;
@protocol LSTableViewCellDelegate;

// ********************************************************************************************************************************************************** //

extern NSString * const kLSTableViewCellID;

// ********************************************************************************************************************************************************** //

@interface LSTableViewCell : UITableViewCell

@property (nonatomic) LSTableViewRow *row;

@property (nonatomic, weak) id delegate;

- (BOOL)canBecomeActive;

- (void)didActivate;
- (void)didDeactivate;

@end

// ********************************************************************************************************************************************************** //

@protocol LSTableViewCellDelegate <NSObject>

@required

- (void)tableViewCellDidBecomeActive:(LSTableViewCell *)cell;
- (void)tableViewCellDidDeactivate:(LSTableViewCell *)cell;

@end
