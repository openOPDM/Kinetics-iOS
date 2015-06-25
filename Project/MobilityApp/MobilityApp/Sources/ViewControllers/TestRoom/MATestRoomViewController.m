//
//  MATestRoomViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/13/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestRoomViewController.h"

#import "DBManager.h"
#import "TestDataManager.h"

#import "MATestSessionReportViewController.h"
#import "MAVideoViewController.h"

#import "MATestSessionReportTableViewCell.h"

#import "MAMessageWebAppResponse.h"
#import "MAUser.h"
#import "MAUserSettings.h"
#import "MAUserWebAppResponse.h"
#import "TestData.h"

#import "MAWebAppManager+MAAccountManagerTasks.h"

static NSString * const kMAPSTCellIdentifier = @"MAPSTCell";
static NSString * const kMATUGCellIdentifier = @"MATUGCell";
static NSString * const kMAPSTVideoSegueIdentifier = @"MAPSTVideoSegue";
static NSString * const kMATUGVideoSegueIdentifier = @"MATUGVideoSegue";
static NSString * const kMATestSessionReportSegueIdentifier = @"MATestSessionReportSegue";
static NSString * const kMASignOutSegueIdentifier = @"MASignOutSegue";

@interface MATestRoomViewController ()

@property (nonatomic) NSMutableArray *dataSource;

@property (nonatomic, getter = isSyncing) BOOL syncing;

@end

@implementation MATestRoomViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getUserInfoWithSessionToken:[MAUser currentUser].sessionToken];
    [self synchronize];
    
    __weak __typeof(self) weakSelf = self;
    
    void (^applicationDidBecomeActiveNotificationBlock)(NSNotification *) = ^(NSNotification *note)
    {
        [weakSelf synchronize];
    };
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:[UIApplication sharedApplication]
                                                       queue:nil
                                                  usingBlock:applicationDidBecomeActiveNotificationBlock];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadViewContent];
}

#pragma mark -
#pragma mark Overridden Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMAPSTVideoSegueIdentifier])
    {
        MAVideoViewController *viewController = segue.destinationViewController;
        viewController.title = kMAWebAppParameterPSTValue;
        viewController.fileURL = [[NSBundle mainBundle] URLForResource:@"PST_SESSION_INSTRUCTIONS" withExtension:@"mp4"];
    }
    else if ([segue.identifier isEqualToString:kMATUGVideoSegueIdentifier])
    {
        MAVideoViewController *viewController = segue.destinationViewController;
        viewController.title = kMAWebAppParameterTUGValue;
        viewController.fileURL = [[NSBundle mainBundle] URLForResource:@"TUG_SESSION_INSTRUCTIONS" withExtension:@"mp4"];
    }
    else if ([segue.identifier isEqualToString:kMATestSessionReportSegueIdentifier])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TestData *testData = self.dataSource[indexPath.row];
        
        MATestSessionReportViewController *viewController = segue.destinationViewController;
        viewController.title = [NSString stringWithFormat:@"%@ Report", testData.type];
        viewController.testData = testData;
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)signOut:(id)sender
{
    [self logoutWithSessionToken:[MAUser currentUser].sessionToken];
}

- (IBAction)refresh:(id)sender
{
    [self synchronize];
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    switch (section)
    {
        case 0:
        {
            numberOfRows = 2;
            break;
        }
        case 1:
        {
            numberOfRows = [self.dataSource count];
            break;
        }
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:kMATUGCellIdentifier forIndexPath:indexPath];
                    break;
                }
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:kMAPSTCellIdentifier forIndexPath:indexPath];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 1:
        {
            __weak __typeof(self) weakSelf = self;
            
            TestData *testData = self.dataSource[indexPath.row];
            
            MATestSessionReportTableViewCell *testReportCell = [tableView dequeueReusableCellWithIdentifier:kMATestSessionReportTableViewCellIdentifier
                                                                                               forIndexPath:indexPath];
            testReportCell.dateLabel.text = [NSDateFormatter ma_stringFromTimeInterval:[testData.creationDate doubleValue]];
            testReportCell.typeLabel.text = testData.type;
            testReportCell.checked = [testData.isValid boolValue];
            testReportCell.didCheckBlock = ^(MATestSessionReportTableViewCell *senderCell)
            {
                NSIndexPath *senderIndexPath = [tableView indexPathForCell:senderCell];
                
                if (senderIndexPath != nil)
                {
                    TestData *senderTestData = weakSelf.dataSource[senderIndexPath.row];
                    senderTestData.isValid = @([senderCell isChecked]);
                    senderTestData.testState = [senderTestData.testState isEqualToString:kTestAdded] ? kTestAdded : kTestUpdated;
                    
                    [[DBManager sharedDatabase] updateEntity];
                }
            };
            
            cell = testReportCell;
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0
    ? NSLocalizedString(@"Tests", nil)
    : [self.dataSource count] > 0 ? NSLocalizedString(@"History", nil) : @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? NO : YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TestData *testData = self.dataSource[indexPath.row];
        testData.testState = kTestDeleted;
        
        [[DBManager sharedDatabase] updateEntity];
        
        [self.dataSource removeObject:testData];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([self.dataSource count] == 0)
        {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark -
#pragma mark <MASyncing>

- (void)reloadViewContent
{
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(userID==%@) AND (testState!=%@)",[MAUser currentUser].identifier, kTestDeleted];
    self.dataSource = [[[[[DBManager sharedDatabase] getAllDataForEntity:@"TestData" withPredicate:predicate] reverseObjectEnumerator] allObjects] mutableCopy];
    
    self.syncing = NO;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)syncFinished
{
    self.syncing = NO;
    [self.refreshControl endRefreshing];
}

#pragma mark -
#pragma mark Private Methods

- (void)synchronize
{
    if (![self isSyncing])
    {
        self.syncing = YES;
        [self.refreshControl beginRefreshing];
        
        [TestDataManager sharedInstance].delegate = self;
        [[TestDataManager sharedInstance] synchroniseData];
    }
}

#pragma mark -
#pragma mark Working with WebApp

- (void)logoutWithSessionToken:(NSString *)sessionToken
{
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MAMessageWebAppResponse *, NSError *) = ^(MAMessageWebAppResponse *response, NSError *error)
    {
        [[DBManager sharedDatabase] deleteAllDataForEntity:@"TestData" withPredicate:nil];
        
        [MAUser setCurrentUser:nil];
        [[MAUserSettings sharedUserSettings] stopSync];
        [MAUserSettings resetSharedUserSettings];
        
        if ([weakSelf shouldPerformSegueWithIdentifier:kMASignOutSegueIdentifier sender:weakSelf])
        {
            [weakSelf performSegueWithIdentifier:kMASignOutSegueIdentifier sender:weakSelf];
        }
    };
    
    [[MAWebAppManager sharedManager] logoutWithSessionToken:sessionToken completionHandler:completionHandler];
}

- (void)getUserInfoWithSessionToken:(NSString *)sessionToken
{
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MAUserWebAppResponse *, NSError *) = ^(MAUserWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error])
        {
            MAUser *user = response.user;
            user.password = [MAUser currentUser].password;
            user.sessionToken = [MAUser currentUser].sessionToken;
            user.currentProject = [MAUser currentUser].currentProject;
            
            [MAUser setCurrentUser:user];
        }
    };
    
    [[MAWebAppManager sharedManager] getUserInfoWithSessionToken:sessionToken completionHandler:completionHandler];
}

@end
