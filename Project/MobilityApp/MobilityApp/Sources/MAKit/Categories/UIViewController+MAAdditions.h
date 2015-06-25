//
//  UIViewController+MAAdditions.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAWebAppResponse;

@interface UIViewController (MAAdditions)

- (void)ma_showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)ma_showAlertWithError:(NSError *)error;

- (BOOL)ma_validateAccountFormString:(NSString *)name;
- (BOOL)ma_validateAccountFormEmail:(NSString *)email;
- (BOOL)ma_validateAccountFormPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword;
- (BOOL)ma_validateResponse:(MAWebAppResponse *)response error:(NSError *)error;

@end
