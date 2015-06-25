//
//  MATestSessionViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/23/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionViewController.h"

#import "ExtensionManager.h"
#import "TestDataManager.h"

#import "MAIsValidTableViewCell.h"
#import "MALockView.h"
#import "MANotesEditorTableViewCell.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"
#import "MAUser.h"
#import "MAUserSettings.h"

NSString * const kMATestSessionCellIdentifier = @"MATestSessionCell";
NSString * const kMAListSegueIdentifier = @"MAListSegue";

@interface MATestSessionViewController ()

@property (nonatomic, copy) MAAudioPlayCompletionBlock audioCompletionBlock;

@end

@implementation MATestSessionViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ExtensionManager sharedInstance] reset];
    
    self.testSession = [MATestSession new];
    self.testSession.isValid = @YES;
    
    self.stateTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionCellIdentifier];
    self.stateTableViewCell.textLabel.text = NSLocalizedString(@"State", nil);
    self.stateTableViewCell.detailTextLabel.text = nil;
    
    self.scoreTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionCellIdentifier];
    self.scoreTableViewCell.textLabel.text = NSLocalizedString(@"Score", nil);
    self.scoreTableViewCell.detailTextLabel.text = nil;
    
    __weak __typeof(self) weakSelf = self;
    
    self.isValidTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAIsValidTableViewCellIdentifier];
    self.isValidTableViewCell.checked = [self.testSession.isValid boolValue];
    self.isValidTableViewCell.didCheckBlock = ^(MAIsValidTableViewCell *isValidCell)
    {
        weakSelf.testSession.isValid = @([isValidCell isChecked]);
    };
    
    self.notesEditorTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMANotesEditorTableViewCellIdentifier];
    
    [self lockViewInteraction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MAUserSettings sharedUserSettings] stopSync];
    
    if (self.testSession.score == nil)
    {
        self.state = MATestSessionViewControllerStatePrepare;
    }
    
    [self reloadViewContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.testSession.score == nil)
    {
        self.state = MATestSessionViewControllerStateUndefined;
    }
    
    [[MAUserSettings sharedUserSettings] startSync];
}

#pragma mark -
#pragma mark Overridden Methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"MALockView" owner:self options:nil];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMAListSegueIdentifier])
    {
        [ExtensionManager sharedInstance].selectedExtension = [self.tableView indexPathForCell:sender];
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setState:(MATestSessionViewControllerState)state
{
    if (_state != state)
    {
        _state = state;
        
        switch (_state)
        {
            case MATestSessionViewControllerStateUndefined:
            {
                self.submitBarButtonItem.enabled = NO;
                
                [self cancelTestSession];
                [self stopAudio];
                
                break;
            }
            case MATestSessionViewControllerStatePrepare:
            {
                self.submitBarButtonItem.enabled = NO;
                self.stateTableViewCell.detailTextLabel.text = NSLocalizedString(@"Getting prepared for start", nil);
                
                [self cancelTestSession];
                [self stopAudio];
                
                break;
            }
            case MATestSessionViewControllerStateStart:
            {
                self.submitBarButtonItem.enabled = NO;
                self.stateTableViewCell.detailTextLabel.text = NSLocalizedString(@"Test is running", nil);
                
                if ([MAUserSettings sharedUserSettings].vibrate)
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                
                [self stopAudio];
                [self performSelector:@selector(startTestSesion) withObject:nil afterDelay:0.25];
                
                break;
            }
            case MATestSessionViewControllerStateStop:
            {
                self.submitBarButtonItem.enabled = YES;
                self.stateTableViewCell.detailTextLabel.text = NSLocalizedString(@"Test is finished", nil);
                
                [self stopTestSession];
                [self playAudioNamed:@"TEST_SESSION_STOP" completion:nil];
                
                if ([MAUserSettings sharedUserSettings].vibrate)
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Methods

- (NSArray *)extensionTableViewCellsForSection:(NSUInteger)section
{
    ExtensionManager *extensionManager = [ExtensionManager sharedInstance];
    NSUInteger extensionCount = [extensionManager getExtensionNum];
    
    NSMutableArray *extensionTableViewCells = [NSMutableArray arrayWithCapacity:extensionCount];
    
    for (NSUInteger index = 0; index < extensionCount; index++)
    {
        UITableViewCell *cell = [[ExtensionManager sharedInstance] getCellForTable:self.tableView
                                                                          forIndex:[NSIndexPath indexPathForRow:index inSection:section]];
        [extensionTableViewCells addObject:cell];
    }
    
    return extensionTableViewCells;
}

- (void)startTestSesion
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)stopTestSession
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancelTestSession
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)lockViewInteraction
{
    self.lockView.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.lockView];
}

- (void)unlockViewInteraction
{
    [self.lockView removeFromSuperview];
}

- (void)playAudioNamed:(NSString *)name completion:(MAAudioPlayCompletionBlock)completion
{
    [self stopAudio];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
    NSError *error;
    
    self.audioCompletionBlock = completion;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.audioPlayer.delegate = self;
    
    if (error != nil)
    {
        [self ma_showAlertWithError:error];
        
        if (self.audioCompletionBlock != nil)
        {
            self.audioCompletionBlock(NO);
        }
    }
    else
    {
        [self.audioPlayer play];
    }
}

- (void)stopAudio
{
    if ([self.audioPlayer isPlaying])
    {
        [self.audioPlayer stop];
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)submit:(id)aSender
{
    if ([[ExtensionManager sharedInstance] validateAllFields])
    {
        self.testSession.notes = self.notesEditorTableViewCell.notesTextView.text;
        
        [self addTestSessionWithSessionToken:[MAUser currentUser].sessionToken testSession:self.testSession];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = UITableViewAutomaticDimension;
    UITableViewCell *cell = self.dataSource[indexPath.section][indexPath.row];
    
    if (cell == self.notesEditorTableViewCell)
    {
        height = kMANotesEditorTableViewCellHeight;
    }
    
    return height;
}

#pragma mark -
#pragma mark <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.audioCompletionBlock != nil)
    {
        self.audioCompletionBlock(flag);
    }
}

#pragma mark -
#pragma mark <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [[ExtensionManager sharedInstance] modifyExtensionForTag:textField.tag WithValue:value];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark -
#pragma mark <MASyncing>

- (void)reloadViewContent
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark -
#pragma mark Working with WebApp

- (void)addTestSessionWithSessionToken:(NSString *)sessionToken testSession:(MATestSession *)testSession
{
    if ((sessionToken != nil) && (testSession.score != nil))
    {
        NSDictionary *dictionary = @{kTestID: @0,
                                     kCreationDate: @([testSession.creationDate doubleValue]),
                                     kIsValid: testSession.isValid,
                                     kType: testSession.type,
                                     kRawData: testSession.rawData.rawDataString,
                                     kScore: testSession.score,
                                     kSynchronised: @NO,
                                     kNotes: [testSession.notes length] > 0 ? testSession.notes : @"",
                                     kExtension: [[ExtensionManager sharedInstance] resultExtension]};
        [[TestDataManager sharedInstance] storeTest:dictionary withTestState:kTestAdded forUser:[MAUser currentUser].identifier syncParam:YES];
    }
}

@end
