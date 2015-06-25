//
//  MAIsValidTableViewCell.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/19/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MACheckbox;

extern NSString * const kMAIsValidTableViewCellIdentifier;

@interface MAIsValidTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *label;
@property (nonatomic) IBOutlet MACheckbox *checkbox;

@property (nonatomic, getter = isChecked) BOOL checked;

@property (nonatomic, copy) void (^didCheckBlock)(MAIsValidTableViewCell *cell);

- (IBAction)check:(id)sender;

@end
