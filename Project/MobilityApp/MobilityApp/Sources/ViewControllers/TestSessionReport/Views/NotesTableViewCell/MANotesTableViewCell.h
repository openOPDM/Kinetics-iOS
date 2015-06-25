//
//  MANotesTableViewCell.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/20/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMANotesTableViewCellIdentifier;

extern const CGFloat kMANotesTableViewCellMinHeight;

@interface MANotesTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *notesLabel;

- (CGFloat)height;

@end
