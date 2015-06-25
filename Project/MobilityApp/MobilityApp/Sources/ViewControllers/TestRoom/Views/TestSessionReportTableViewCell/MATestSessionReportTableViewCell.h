//
//  MATestSessionReportTableViewCell.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/19/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MACheckbox;

extern NSString * const kMATestSessionReportTableViewCellIdentifier;

@interface MATestSessionReportTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet MACheckbox *checkbox;
@property (nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, getter = isChecked) BOOL checked;

@property (nonatomic, copy) void (^didCheckBlock)(MATestSessionReportTableViewCell *cell);

- (IBAction)check:(id)sender;

@end
