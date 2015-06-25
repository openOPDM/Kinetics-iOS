//
//  MACheckbox.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/19/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MACheckbox.h"

@implementation MACheckbox

#pragma mark -
#pragma mark Overridden Accessors

- (CGFloat)strokeWidth
{
    return 1.0;
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat widthDelta = 44.0 - CGRectGetWidth(self.bounds);
    CGFloat heightDelta = 44.0 - CGRectGetHeight(self.bounds);
    
    CGRect bounds = CGRectInset(self.bounds, -0.5 * widthDelta, - 0.5 * heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}

@end
