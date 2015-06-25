//
//  AppDelegate.m
//  MotionApp
//
//  Created by Dima Vlasenko on 12/27/12.
//  Copyright (c) 2012 Kinetics Foundation. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark -
#pragma mark <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.idleTimerDisabled = YES;
    
    [self validateCurrentDevice];
    
    return YES;
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)validateCurrentDevice
{
    UIDevice *device = [UIDevice currentDevice];
    
    BOOL isValidated = [device isMa_certified];
    
    if (!isValidated)
    {
        NSString *title = NSLocalizedString(@"We’re Sorry But This Device is Not Yet Certified", nil);
        NSString *message = [NSString stringWithFormat:
                             NSLocalizedString(@"Certified devices include %@. "
                                               "If you use non certified device, results may be inconsistent with other devices.", nil),
                             [device ma_certifiedDevices]];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    
    return isValidated;
}

@end
 