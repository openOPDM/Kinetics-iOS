//
//  MAIsValidTableViewCell.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/19/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAIsValidTableViewCell.h"

#import "MACheckbox.h"

NSString * const kMAIsValidTableViewCellIdentifier = @"MAIsValidCell";

@implementation MAIsValidTableViewCell

#pragma mark -
#pragma mark Overridden Methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.checkbox addTarget:self action:@selector(check:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark Accessors

- (BOOL)isChecked
{
    return self.checkbox.checkState;
}

- (void)setChecked:(BOOL)checked
{
    self.checkbox.checkState = checked;
}

#pragma mark -
#pragma mark Actions

- (IBAction)check:(id)sender
{
    if (self.didCheckBlock != nil)
    {
        self.didCheckBlock(self);
    }
}

@end
