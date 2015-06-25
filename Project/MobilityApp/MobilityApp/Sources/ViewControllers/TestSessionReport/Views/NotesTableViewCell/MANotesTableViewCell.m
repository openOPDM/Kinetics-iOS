//
//  MANotesTableViewCell.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/20/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MANotesTableViewCell.h"

NSString * const kMANotesTableViewCellIdentifier = @"MANotesCell";

const CGFloat kMANotesTableViewCellMinHeight = 65.0;

@implementation MANotesTableViewCell

#pragma mark -
#pragma mark Methods

- (CGFloat)height
{
    // Known values.
    static CGFloat topMargin = 11.0;
    static CGFloat bottomMargin = 11.0;
    
    // Calculated values.
    CGSize size = CGSizeMake(CGRectGetWidth(self.notesLabel.bounds), CGFLOAT_MAX);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{NSFontAttributeName: self.notesLabel.font};
    CGRect notesLabelBoundingRect = [self.notesLabel.text boundingRectWithSize:size options:options attributes:attributes context:nil];
    
    CGFloat height = MAX(kMANotesTableViewCellMinHeight,
                         topMargin + CGRectGetHeight(self.titleLabel.bounds) + ceil(CGRectGetHeight(notesLabelBoundingRect)) + bottomMargin);
    
    return height;
}

@end
