//
//  LSTableViewSection.h
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/12/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <Foundation/Foundation.h>

// ********************************************************************************************************************************************************** //

@interface LSTableViewSection : NSObject

@property (nonatomic, copy) NSString *titleForHeader;
@property (nonatomic, copy) NSString *titleForFooter;

@property (nonatomic) NSMutableArray *rows; // Array of LSTableViewRow objects.

@end
