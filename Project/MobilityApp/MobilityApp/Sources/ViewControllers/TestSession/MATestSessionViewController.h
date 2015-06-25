//
//  MATestSessionViewController.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/23/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import "MASyncing.h"

@class MAIsValidTableViewCell;
@class MALockView;
@class MANotesEditorTableViewCell;

@class MATestSession;

typedef NS_ENUM(NSUInteger, MATestSessionViewControllerState)
{
    MATestSessionViewControllerStateUndefined,
    MATestSessionViewControllerStatePrepare,
    MATestSessionViewControllerStateStart,
    MATestSessionViewControllerStateStop
};

typedef void (^MAAudioPlayCompletionBlock)(BOOL success);

extern NSString * const kMATestSessionCellIdentifier;
extern NSString * const kMAListSegueIdentifier;

@interface MATestSessionViewController : UITableViewController <AVAudioPlayerDelegate, UITextFieldDelegate, MASyncing>

@property (nonatomic) IBOutlet UIBarButtonItem *submitBarButtonItem;
@property (nonatomic) IBOutlet MALockView *lockView;

@property (nonatomic) UITableViewCell *stateTableViewCell;
@property (nonatomic) UITableViewCell *scoreTableViewCell;
@property (nonatomic) MAIsValidTableViewCell *isValidTableViewCell;
@property (nonatomic) MANotesEditorTableViewCell *notesEditorTableViewCell;

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) MATestSession *testSession;

@property (nonatomic) MATestSessionViewControllerState state;

- (NSArray *)extensionTableViewCellsForSection:(NSUInteger)section;

- (void)startTestSesion;
- (void)stopTestSession;
- (void)cancelTestSession;

- (void)lockViewInteraction;
- (void)unlockViewInteraction;

- (void)playAudioNamed:(NSString *)name completion:(MAAudioPlayCompletionBlock)completion;
- (void)stopAudio;

- (IBAction)submit:(id)sender;

@end
