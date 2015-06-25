//
//  MACalibrateViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/21/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MACalibrateViewController.h"

#import <CoreMotion/CoreMotion.h>

#import "MAPSTSessionManager.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"
#import "MAUserSettings.h"

@implementation MACalibrateViewController

#pragma mark -
#pragma mark Actions

- (IBAction)calibrate:(id)sender
{
    __block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Calibrating…", nil)
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                      otherButtonTitles:nil];
    [alertView show];
    
    MAPSTSessionManager *pstSessionManager = [MAPSTSessionManager sharedManager];
    
    __weak __typeof(pstSessionManager) weakPSTSessionManager = pstSessionManager;
    
    pstSessionManager.testSessionCompletionBlock = ^(MATestSession *testSession)
    {
        weakPSTSessionManager.calibratedJERKValue = kMAPSTReferenceJERKValue / [testSession.score doubleValue];
        weakPSTSessionManager.calibratedAREAValue = kMAPSTReferenceAREAValue / [testSession.rawData.area doubleValue];
        weakPSTSessionManager.calibratedRMSValue = kMAPSTReferenceRMSValue / [testSession.rawData.rms doubleValue];
        
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Calibration is Completed", nil)
                                               message:nil
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                     otherButtonTitles:nil];
        [alertView show];
    };
    
    [pstSessionManager resetCalibratedValues];
    [pstSessionManager startTestSessionWithDeviceMotionUpdateInterval:[MAUserSettings sharedUserSettings].updateRate];
}

- (IBAction)reset:(id)sender
{
    [[MAPSTSessionManager sharedManager] resetCalibratedValues];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Calibration is Reset", nil)
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.calibrateTableViewCell)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self calibrate:cell];
    }
    else if (cell == self.resetCalibraionTableViewCell)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self reset:cell];
    }
}

#pragma mark -
#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [[MAPSTSessionManager sharedManager] cancelTestSession];
    }
}

@end
