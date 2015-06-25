//
//  MAPSTSessionViewController.m
//  MotionApp
//
//  Created by Dima Vlasenko on 1/14/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MAPSTSessionViewController.h"

#import "MAPSTSessionManager.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"
#import "MAUserSettings.h"

@implementation MAPSTSessionViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.testSession.type = kMAWebAppParameterPSTValue;
    
    self.progressTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionCellIdentifier];
    self.progressTableViewCell.textLabel.text = NSLocalizedString(@"Seconds Left", nil);
    self.progressTableViewCell.detailTextLabel.text = nil;
    
    self.scoreTableViewCell.textLabel.text = NSLocalizedString(@"JERK", nil);
    
    self.areaTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionCellIdentifier];
    self.areaTableViewCell.textLabel.text = NSLocalizedString(@"AREA", nil);
    self.areaTableViewCell.detailTextLabel.text = nil;
    
    self.rmsTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionCellIdentifier];
    self.rmsTableViewCell.textLabel.text = NSLocalizedString(@"RMS", nil);
    self.rmsTableViewCell.detailTextLabel.text = nil;
}

#pragma mark -
#pragma mark Overridden Accessors

- (void)setState:(MATestSessionViewControllerState)state
{
    [super setState:state];
    
    switch (self.state)
    {
        case MATestSessionViewControllerStatePrepare:
        {
            self.progressTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f", kMAPSTSessionDuration];
            
            __weak __typeof(self) weakSelf = self;
            
            [self playAudioNamed:@"PST_SESSION_INSTRUCTION" completion:^(BOOL success1)
            {
                [weakSelf playAudioNamed:@"TEST_SESSION_START" completion:^(BOOL success2)
                {
                    weakSelf.state = MATestSessionViewControllerStateStart;
                }];
            }];
            
            break;
        }
        case MATestSessionViewControllerStateStart:
        {
            self.progressTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f", kMAPSTSessionDuration];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Test Session Lifecycle

- (void)startTestSesion
{
    __weak __typeof(self) weakSelf = self;
    
    MAPSTSessionManager *pstSessionManager = [MAPSTSessionManager sharedManager];
    pstSessionManager.testSessionProgressBlock = ^(NSTimeInterval secondsLeft)
    {
        weakSelf.progressTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.f", secondsLeft];
    };
    pstSessionManager.testSessionCompletionBlock = ^(MATestSession *testSession)
    {
        if (weakSelf.state == MATestSessionViewControllerStateStart)
        {
            weakSelf.testSession.creationDate = testSession.creationDate;
            weakSelf.testSession.score = testSession.score;
            weakSelf.testSession.rawData = testSession.rawData;
            
            [weakSelf reloadViewContent];
            
            weakSelf.state = MATestSessionViewControllerStateStop;
        }
    };
    
    [pstSessionManager startTestSessionWithDeviceMotionUpdateInterval:[MAUserSettings sharedUserSettings].updateRate];
}

- (void)stopTestSession
{
    [[MAPSTSessionManager sharedManager] stopTestSession];
}

- (void)cancelTestSession
{
    [[MAPSTSessionManager sharedManager] cancelTestSession];
}

#pragma mark -
#pragma mark <MASyncing>

- (void)reloadViewContent
{
    self.scoreTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%f %@",
                                                    [self.testSession.score doubleValue], NSLocalizedString(@"m²/sec⁵", nil)];
    self.areaTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%f %@",
                                                   [self.testSession.rawData.area doubleValue], NSLocalizedString(@"m²/sec⁵", nil)];
    self.rmsTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%f %@",
                                                  [self.testSession.rawData.rms doubleValue], NSLocalizedString(@"m/sec²", nil)];
    
    // Test session section.
    NSArray *testSessionSection = @[self.stateTableViewCell,
                                    self.progressTableViewCell,
                                    self.scoreTableViewCell,
                                    self.areaTableViewCell,
                                    self.rmsTableViewCell,
                                    self.isValidTableViewCell,
                                    self.notesEditorTableViewCell];
    
    // Extensions section.
    NSArray *extensionsSection = [self extensionTableViewCellsForSection:1];
    
    self.dataSource = @[testSessionSection, extensionsSection];
    
    [self.tableView reloadData];
}

@end
