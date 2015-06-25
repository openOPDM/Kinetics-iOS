//
//  ExtensionNonListCell.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionNonListCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UITextField* extField;
@property(nonatomic, strong) IBOutlet UILabel* extName;

@end
