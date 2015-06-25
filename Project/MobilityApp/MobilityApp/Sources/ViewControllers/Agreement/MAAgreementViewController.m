//
//  MAAgreementViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAAgreementViewController.h"

@interface MAAgreementViewController ()

@property (nonatomic, readonly) NSURL *privacyPolicyURL;
@property (nonatomic, readonly) NSURL *termsOfServiceURL;

@end

@implementation MAAgreementViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.type)
    {
        case MAAgreementPrivacyPolicyType:
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.privacyPolicyURL]];
            break;
        }
        case MAAgreementTermsOfServiceType:
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.termsOfServiceURL]];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark -
#pragma mark Actions

- (IBAction)goBack:(id)sender
{
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender
{
    [self.webView goForward];
}

- (IBAction)reload:(id)sender
{
    [self.webView reload];
}

#pragma mark -
#pragma mark <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = YES;
    
    if ([[request URL] isEqual:self.privacyPolicyURL])
    {
        self.type = MAAgreementPrivacyPolicyType;
    }
    else if ([[request URL] isEqual:self.termsOfServiceURL])
    {
        self.type = MAAgreementTermsOfServiceType;
    }
    else
    {
        shouldLoad = NO;
        
        [[UIApplication sharedApplication] openURL:[request URL]];
    }
    
    return shouldLoad;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateUI];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateUI];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateUI];
}

#pragma mark -
#pragma mark Private Accessors

- (NSURL *)privacyPolicyURL
{
    return [[NSBundle mainBundle] URLForResource:@"PRIVACY_POLICY" withExtension:@"html"];
}

- (NSURL *)termsOfServiceURL
{
    return [[NSBundle mainBundle] URLForResource:@"TERMS_OF_SERVICE" withExtension:@"html"];
}

#pragma mark -
#pragma mark Helpers

- (void)updateUI
{
    switch (self.type)
    {
        case MAAgreementPrivacyPolicyType:
        {
            self.title = NSLocalizedString(@"Privacy Policy", nil);
            break;
        }
        case MAAgreementTermsOfServiceType:
        {
            self.title = NSLocalizedString(@"Terms of Service", nil);
            break;
        }
        default:
            break;
    }
    
    self.backBarButtonItem.enabled = [self.webView canGoBack];
    self.forwardBarButtonItem.enabled = [self.webView canGoForward];
    self.reloadBarButtonItem.enabled = self.webView.request != nil;
}

@end
