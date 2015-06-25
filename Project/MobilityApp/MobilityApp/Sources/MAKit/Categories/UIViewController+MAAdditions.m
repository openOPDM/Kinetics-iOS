//
//  UIViewController+MAAdditions.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "UIViewController+MAAdditions.h"

#import "MAWebAppResponse.h"

@interface UIViewController (MAAdditionsPrivate)

- (void)ma_handleError:(NSError *)error;
- (void)ma_handleWebAppError:(NSError *)error;

@end

@implementation UIViewController (MAAdditions)

#pragma mark -
#pragma mark Methods

- (void)ma_showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)ma_showAlertWithError:(NSError *)error
{
    [self ma_showAlertWithTitle:[error localizedDescription] message:[error localizedFailureReason]];
}

- (BOOL)ma_validateAccountFormString:(NSString *)name
{
    BOOL isValidated = NO;
    
    if ([name length] > 0)
    {
        isValidated = YES;
    }
    else
    {
        [self ma_showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Please fill all fields.", nil)];
    }
    
    return isValidated;
}

- (BOOL)ma_validateAccountFormEmail:(NSString *)email
{
    BOOL isValidated = NO;
    
    if ([email length] > 0)
    {
        NSString *pattern = @"[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,30})+";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:email options:kNilOptions range:NSMakeRange(0, [email length])];
        
        if (match != nil)
        {
            isValidated = YES;
        }
        else
        {
            [self ma_showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Please supply a valid email address.", nil)];
        }
    }
    else
    {
        [self ma_showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Please supply a valid email address.", nil)];
    }
    
    return isValidated;
}

- (BOOL)ma_validateAccountFormPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    BOOL isValidated = NO;
    
    if ([password isEqualToString:confirmPassword])
    {
        isValidated = YES;
    }
    else
    {
        [self ma_showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"The passwords do not match.", nil)];
    }
    
    return isValidated;
}

- (BOOL)ma_validateResponse:(MAWebAppResponse *)response error:(NSError *)error
{
    BOOL isValidated = NO;
    
    if (error != nil)
    {
        [self ma_handleError:error];
    }
    else
    {
        if (response.error != nil)
        {
            [self ma_handleWebAppError:response.error];
        }
        else
        {
            isValidated = YES;
        }
    }
    
    return isValidated;
}

@end

@implementation UIViewController (MAAdditionsPrivate)

- (void)ma_handleError:(NSError *)error
{
    if ([[error domain] isEqualToString:NSURLErrorDomain])
    {
        switch ([error code])
        {
            case NSURLErrorCancelled:
            {
                // Do nothing;
                break;
            }
            default:
            {
                [self ma_showAlertWithError:error];
                break;
            }
        }
    }
}

- (void)ma_handleWebAppError:(NSError *)error
{
    if ([[error domain] isEqualToString:kMAWebAppErrorDomain])
    {
        if ([error code] == kMAWebAppResponseErrorCodeInvalidSessionToken || [error code] == kMAWebAppResponseErrorCodeSessionTokenIsExpired)
        {
            
        }
        else if ([error code] == kMAWebAppResponseErrorCodeUserNotActive)
        {
            NSString *localizedDescription = [NSString stringWithFormat:
                                              NSLocalizedString(@"%@ please confirm your account by sending secure code", nil),
                                              [error localizedDescription]];
            error = [NSError errorWithDomain:[error domain] code:[error code] userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
        }
        
        [self ma_showAlertWithError:error];
    }
}

@end
