//
//  MANotesEditorTableViewCell.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/23/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMANotesEditorTableViewCellIdentifier;

extern const CGFloat kMANotesEditorTableViewCellHeight;

@interface MANotesEditorTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UITextView *notesTextView;

@end
