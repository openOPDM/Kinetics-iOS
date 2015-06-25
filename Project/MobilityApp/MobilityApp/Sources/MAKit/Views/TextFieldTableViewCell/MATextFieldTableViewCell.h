//
//  MATextFieldTableViewCell.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 4/30/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMATextFieldTableViewCellIdentifier;

@interface MATextFieldTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *label;
@property (nonatomic) IBOutlet UITextField *textField;

@end
