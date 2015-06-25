//
//  ExtensionListCell.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "ExtensionListCell.h"

@implementation ExtensionListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
