//
//  LSTableViewCell.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/14/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewCell.h"

#import "LSTableViewRow.h"

// ********************************************************************************************************************************************************** //

NSString * const kLSTableViewCellID = @"LSTableViewCell";

// ********************************************************************************************************************************************************** //

@implementation LSTableViewCell

#pragma mark -
#pragma mark Object Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = (style == UITableViewCellStyleDefault) ? UITableViewCellStyleValue1 : style;
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)dealloc
{
    [_row removeObserver:self forKeyPath:@"activated" context:NULL];
}

#pragma mark -
#pragma mark Overridden Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.row.activated = ![self.row isActivated];
        
        if (self.row.didSelectBlock != nil)
        {
            self.row.didSelectBlock(self.row);
        }
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setRow:(LSTableViewRow *)row
{
    if (_row != row)
    {
        [_row removeObserver:self forKeyPath:@"activated" context:NULL];
        _row = row;
        [_row addObserver:self forKeyPath:@"activated" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        
        self.imageView.image = _row.image;
        self.textLabel.text = _row.labelText;
        self.detailTextLabel.text = _row.detailLabelText;
        
        self.selectionStyle = _row.selectionStyle;
        
        self.accessoryType = _row.accessoryType;
        self.accessoryView = _row.accessoryView;
    }
}

#pragma mark -
#pragma mark Methods

- (BOOL)canBecomeActive
{
    return NO;
}

- (void)didActivate
{
    [self.delegate tableViewCellDidBecomeActive:self];
}

- (void)didDeactivate
{
    [self.delegate tableViewCellDidDeactivate:self];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.row)
    {
        if ([keyPath isEqualToString:@"activated"])
        {
            if ([self canBecomeActive])
            {
                NSNumber *newActivated = change[NSKeyValueChangeNewKey];
                NSNumber *oldActivated = change[NSKeyValueChangeOldKey];
                
                if (![newActivated isEqual:oldActivated])
                {
                    if ([newActivated boolValue])
                    {
                        [self didActivate];
                    }
                    else
                    {
                        [self didDeactivate];
                    }
                }
            }
        }
    }
}

@end
