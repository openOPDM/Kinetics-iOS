//
//  MAAgreementTableViewFooterView.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/26/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAAgreementTableViewFooterView.h"

NSString * const kMAAgreementTableViewFooterViewIdentifier = @"MAAgreementFooterView";

const CGFloat kMAAgreementTableViewFooterViewHeight = 54.0;

static NSString *kMAPrivacyPolicyURLString = @"www.MAPrivacyPolicy.com";
static NSString *kMATermsOfServiceURLString = @"www.MATermsOfService.com";

@implementation MAAgreementTableViewFooterView

#pragma mark -
#pragma mark Overridden Methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableDictionary *linkAttributes = [self.attributedLabel.linkAttributes mutableCopy];
    linkAttributes[NSForegroundColorAttributeName] = self.attributedLabel.tintColor;
    
    self.attributedLabel.linkAttributes = linkAttributes;
    self.attributedLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:kMAPrivacyPolicyURLString]
                             withRange:[self.attributedLabel.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:kMATermsOfServiceURLString]
                             withRange:[self.attributedLabel.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
}

#pragma mark -
#pragma mark <TTTAttributedLabelDelegate>

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([url isEqual:[NSURL URLWithString:kMAPrivacyPolicyURLString]])
    {
        if (self.didSelectPrivacyPolicyBlock != nil)
        {
            self.didSelectPrivacyPolicyBlock();
        }
    }
    else if ([url isEqual:[NSURL URLWithString:kMATermsOfServiceURLString]])
    {
        if (self.didSelectTermsOfServiceBlock != nil)
        {
            self.didSelectTermsOfServiceBlock();
        }
    }
}

@end
