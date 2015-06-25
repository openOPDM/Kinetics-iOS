//
//  MAAgreementViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MAAgreementType)
{
    MAAgreementUnknownType,
    MAAgreementPrivacyPolicyType,
    MAAgreementTermsOfServiceType
};

@interface MAAgreementViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *reloadBarButtonItem;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic) MAAgreementType type;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reload:(id)sender;

@end
