//
//  MATUGSessionViewController.m
//  MotionApp
//
//  Created by Dima Vlasenko on 12/27/12.
//  Copyright (c) 2012 Kinetics Foundation. All rights reserved.
//

#import "MATUGSessionViewController.h"

#import "MATUGSessionManager.h"

#import "MATestSession.h"
#import "MAUserSettings.h"

@implementation MATUGSessionViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.testSession.type = kMAWebAppParameterTUGValue;
    
    self.scoreTableViewCell.textLabel.text = NSLocalizedString(@"Duration", nil);
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
            self.scoreTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f %@", 0.0, NSLocalizedString(@"sec", nil)];
            
            __weak __typeof(self) weakSelf = self;
            
            [self playAudioNamed:@"TUG_SESSION_INSTRUCTION" completion:^(BOOL success)
            {
                weakSelf.state = MATestSessionViewControllerStateStart;
            }];
            
            break;
        }
        case MATestSessionViewControllerStateStart:
        {
            self.scoreTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f %@", 0.0, NSLocalizedString(@"sec", nil)];
            
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
    
    MATUGSessionManager *tugSessionManager = [MATUGSessionManager sharedManager];
    tugSessionManager.testSessionProgressBlock = ^(NSTimeInterval duration)
    {
        weakSelf.scoreTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f %@", duration, NSLocalizedString(@"sec", nil)];
    };
    tugSessionManager.testSessionCompletionBlock = ^(MATestSession *testSession)
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
    
    [tugSessionManager startTestSessionWithDeviceMotionUpdateInterval:[MAUserSettings sharedUserSettings].updateRate];
}

- (void)stopTestSession
{
    [[MATUGSessionManager sharedManager] stopTestSession];
}

- (void)cancelTestSession
{
    [[MATUGSessionManager sharedManager] cancelTestSession];
}

#pragma mark -
#pragma mark <MASyncing>

- (void)reloadViewContent
{
    // Test session section.
    NSArray *testSessionSection = @[self.stateTableViewCell,
                                    self.scoreTableViewCell,
                                    self.isValidTableViewCell,
                                    self.notesEditorTableViewCell];
    
    // Extensions section.
    NSArray *extensionsSection = [self extensionTableViewCellsForSection:1];
    
    self.dataSource = @[testSessionSection, extensionsSection];
    
    [self.tableView reloadData];
}

@end
