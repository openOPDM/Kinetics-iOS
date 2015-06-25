//
//  MATestSessionReportViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionReportViewController.h"

#import "DBManager.h"
#import "TestDataManager.h"

#import "MATestSessionGraphViewController.h"
#import "MATestSessionRawDataViewController.h"

#import "MANotesTableViewCell.h"

#import "MATestSession.h"
#import "MATestSessionRawData.h"
#import "MATestSessionWebAppResponse.h"
#import "MAUser.h"
#import "TestData.h"

#import "MAWebAppManager+MATestSessionManagerTasks.h"

static NSString * const kMATestSessionGraphCellIdentifier = @"MATestSessionGraphCell";
static NSString * const kMATestSessionRawDataCellIdentifier = @"MATestSessionRawDataCell";
static NSString * const kMATestSessionReportCellIdentifier = @"MATestSessionReportCell";
static NSString * const kMATestSessionGraphSegueIdentifier = @"MATestSessionGraphSegue";
static NSString * const kMATestSessionRawDataSegueIdentifier = @"MATestSessionRawDataSegue";

@interface MATestSessionReportViewController ()

@property (nonatomic) MATestSessionRawData *testRawData;
@property (nonatomic) NSMutableDictionary *testExtension;

@property (nonatomic) NSArray *dataSource;

@end

@implementation MATestSessionReportViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.testDateTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
    self.testDateTableViewCell.textLabel.text = NSLocalizedString(@"Date", nil);
    self.testDateTableViewCell.detailTextLabel.text = nil;
    
    self.testIsValidTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
    self.testIsValidTableViewCell.textLabel.text = NSLocalizedString(@"Is Valid", nil);
    self.testIsValidTableViewCell.detailTextLabel.text = nil;
    
    self.testNotesTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMANotesTableViewCellIdentifier];
    self.testNotesTableViewCell.notesLabel.text = nil;
    
    if ([self.testData.type isEqualToString:kMAWebAppParameterPSTValue])
    {
        self.testGraphTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionGraphCellIdentifier];
        self.testRawDataTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionRawDataCellIdentifier];
        
        self.testPSTJERKTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
        self.testPSTJERKTableViewCell.textLabel.text = NSLocalizedString(@"JERK", nil);
        self.testPSTJERKTableViewCell.detailTextLabel.text = nil;
        
        self.testPSTAREATableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
        self.testPSTAREATableViewCell.textLabel.text = NSLocalizedString(@"AREA", nil);
        self.testPSTAREATableViewCell.detailTextLabel.text = nil;
        
        self.testPSTRMSTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
        self.testPSTRMSTableViewCell.textLabel.text = NSLocalizedString(@"RMS", nil);
        self.testPSTRMSTableViewCell.detailTextLabel.text = nil;
    }
    else if ([self.testData.type isEqualToString:kMAWebAppParameterTUGValue])
    {
        self.testTUGDurationTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
        self.testTUGDurationTableViewCell.textLabel.text = NSLocalizedString(@"Duration", nil);
        self.testTUGDurationTableViewCell.detailTextLabel.text = nil;
    }
    
    [self reloadViewContent];
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldPerform = YES;
    
    if ([identifier isEqualToString:kMATestSessionGraphSegueIdentifier] ||
        [identifier isEqualToString:kMATestSessionRawDataSegueIdentifier])
    {
        shouldPerform = self.testRawData != nil;
    }
    
    return shouldPerform;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMATestSessionGraphSegueIdentifier])
    {
        MATestSessionGraphViewController *viewController = segue.destinationViewController;
        viewController.testRawData = self.testRawData;
    }
    else if ([segue.identifier isEqualToString:kMATestSessionRawDataSegueIdentifier])
    {
        MATestSessionRawDataViewController *viewController = segue.destinationViewController;
        viewController.testRawData = self.testRawData;
    }
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
    
    if (cell == self.testNotesTableViewCell)
    {
        height = [self.testNotesTableViewCell height];
    }
    
    return height;
}

#pragma mark -
#pragma mark <MASyncing>

- (void)reloadViewContent
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testID==%@", self.testData.testID];
    TestData *testData = [[[DBManager sharedDatabase] getAllDataForEntity:@"TestData" withPredicate:predicate] firstObject];
    
    if (testData != nil)
    {
        if ([testData.rawData length] != 0)
        {
            self.testRawData = [MATestSessionRawData rawDataWithRawDataString:testData.rawData];
            [self parseExtension:testData.extension];
        }
        else
        {
            [self getTestSessionDetailsWithSessionToken:[MAUser currentUser].sessionToken identifier:testData.testID];
        }
    }
    
    // Update table view cells.
    self.testDateTableViewCell.detailTextLabel.text = testData.creationDate != nil
    ? [NSDateFormatter ma_stringFromTimeInterval:[testData.creationDate doubleValue]]
    : NSLocalizedString(@"Not Valid", nil);
    
    self.testIsValidTableViewCell.detailTextLabel.text = testData.isValid != nil
    ? [testData.isValid boolValue] ? NSLocalizedString(@"YES", nil) : NSLocalizedString(@"NO", nil)
    : NSLocalizedString(@"Not Valid", nil);
    
    self.testNotesTableViewCell.notesLabel.text = testData.notes;
    
    if ([testData.type isEqualToString:kMAWebAppParameterPSTValue])
    {
        self.testPSTJERKTableViewCell.detailTextLabel.text = testData.score != nil
        ? [NSString stringWithFormat:@"%f m²/sec⁵", [testData.score doubleValue]]
        : NSLocalizedString(@"Not Valid", nil);
        
        self.testPSTAREATableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ m²/sec⁵",
                                                              self.testRawData.area != nil ? self.testRawData.area : @"0"];
        
        self.testPSTRMSTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ m/sec²",
                                                             self.testRawData.rms != nil ? self.testRawData.rms : @"0"];
    }
    else if ([testData.type isEqualToString:kMAWebAppParameterTUGValue])
    {
        self.testTUGDurationTableViewCell.detailTextLabel.text = testData.score != nil
        ? [NSString stringWithFormat:@"%.2f sec", [testData.score doubleValue]]
        : NSLocalizedString(@"Not Valid", nil);
    }
    
    // Test session section.
    NSArray *testSessionSection = nil;
    
    if ([self.testData.type isEqualToString:kMAWebAppParameterPSTValue])
    {
        testSessionSection = @[self.testDateTableViewCell,
                               self.testPSTJERKTableViewCell,
                               self.testPSTAREATableViewCell,
                               self.testPSTRMSTableViewCell,
                               self.testIsValidTableViewCell,
                               self.testGraphTableViewCell,
                               self.testRawDataTableViewCell,
                               self.testNotesTableViewCell];
    }
    else if ([self.testData.type isEqualToString:kMAWebAppParameterTUGValue])
    {
        testSessionSection = @[self.testDateTableViewCell,
                               self.testTUGDurationTableViewCell,
                               self.testIsValidTableViewCell,
                               self.testNotesTableViewCell];
    }
    else
    {
        testSessionSection = @[self.testDateTableViewCell];
    }
    
    // Extensions section.
    NSMutableArray *extensionsSection = [NSMutableArray arrayWithCapacity:[[self.testExtension allKeys] count]];
    
    for (NSUInteger index = 0; index < [[self.testExtension allKeys] count]; index++)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMATestSessionReportCellIdentifier];
        cell.textLabel.text = [self.testExtension allKeys][index];
        cell.detailTextLabel.text = [self.testExtension valueForKey:[self.testExtension allKeys][index]];
        
        [extensionsSection addObject:cell];
    }
    
    self.dataSource = @[testSessionSection, extensionsSection];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Private Methods

- (void)parseExtension:(NSString*)anExtension
{
    self.testExtension = [NSMutableDictionary dictionary];
    
    NSArray* theArr = [anExtension componentsSeparatedByString:@";"];
    for (NSString* theStr in theArr) {
        NSArray* theComp = [theStr componentsSeparatedByString:@","];
        if ([theComp[0] length]>0)
            [self.testExtension setValue:theComp[2] forKey:theComp[0]];
    }
}

#pragma mark -
#pragma mark Working with WebApp

- (void)getTestSessionDetailsWithSessionToken:(NSString *)sessionToken identifier:(NSNumber *)identifier
{
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MATestSessionWebAppResponse *, NSError *) = ^(MATestSessionWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testID==%@", identifier];
            TestData *testData = [[[DBManager sharedDatabase] getAllDataForEntity:@"TestData" withPredicate:predicate] firstObject];
            testData.rawData = response.testSession.rawData.rawDataString;
            testData.extension =  [[TestDataManager sharedInstance] stringFromExtensions:response.testSession.extension];
            
            [[DBManager sharedDatabase] updateEntity];
            
            [weakSelf reloadViewContent];
        }
    };
    
    [[MAWebAppManager sharedManager] getTestSessionDetailsWithSessionToken:sessionToken identifier:identifier completionHandler:completionHandler];
}

@end
