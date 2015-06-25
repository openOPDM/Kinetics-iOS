//
//  MAAgreementTableViewFooterView.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/26/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTAttributedLabel.h"

extern NSString * const kMAAgreementTableViewFooterViewIdentifier;

extern const CGFloat kMAAgreementTableViewFooterViewHeight;

@interface MAAgreementTableViewFooterView : UITableViewHeaderFooterView <TTTAttributedLabelDelegate>

@property (nonatomic) IBOutlet TTTAttributedLabel *attributedLabel;

@property (nonatomic, copy) void (^didSelectPrivacyPolicyBlock)();
@property (nonatomic, copy) void (^didSelectTermsOfServiceBlock)();

@end
