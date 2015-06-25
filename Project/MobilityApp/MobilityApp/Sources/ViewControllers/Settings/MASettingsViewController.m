//
//  MASettingsViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/12/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MASettingsViewController.h"

#import "MAAgreementViewController.h"
#import "MAParentPickerViewTableViewCell.h"
#import "MAProject.h"
#import "MAUser.h"
#import "MAUserSettings.h"

#import "LSPickerViewComponent.h"
#import "LSPickerViewRow.h"
#import "LSPickerViewTableViewRow.h"
#import "LSSwitchTableViewRow.h"
#import "LSTableViewSection.h"
#import "MAParentPickerViewTableViewRow.h"

static NSString * const kMAPrivacyPolicySegueIdentifier = @"MAPrivacyPolicySegue";
static NSString * const kMATermsOfServiceSegueIdentifier = @"MATermsOfServiceSegue";
static NSString * const kMACalibrateSegueIdentifier = @"MACalibrateSegue";

@implementation MASettingsViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[MAParentPickerViewTableViewCell class] forCellReuseIdentifier:kMAParentPickerViewTableViewCellIdentifier];
    
    // Initialize the sections array.
    self.dataSource = @[[self settingsTableViewSection], [self aboutTableViewSection]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[MAUserSettings sharedUserSettings] startSync];
}

#pragma mark -
#pragma mark Overridden Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMAPrivacyPolicySegueIdentifier])
    {
        MAAgreementViewController *viewController = segue.destinationViewController;
        viewController.navigationItem.leftBarButtonItem = nil;
        viewController.navigationItem.rightBarButtonItem = nil;
        viewController.type = MAAgreementPrivacyPolicyType;
    }
    else if ([segue.identifier isEqualToString:kMATermsOfServiceSegueIdentifier])
    {
        MAAgreementViewController *viewController = segue.destinationViewController;
        viewController.navigationItem.leftBarButtonItem = nil;
        viewController.navigationItem.rightBarButtonItem = nil;
        viewController.type = MAAgreementTermsOfServiceType;
    }
}

#pragma mark -
#pragma mark Private Methods

- (LSTableViewSection *)settingsTableViewSection
{
    __weak __typeof(self) weakSelf = self;
    
    LSTableViewSection *tableViewSection = [LSTableViewSection new];
    tableViewSection.rows = [NSMutableArray arrayWithCapacity:2];
    
    // Sync period cell.
    {
        LSPickerViewRow *onePickerViewRow = [LSPickerViewRow new];
        onePickerViewRow.title = NSLocalizedString(@"Hourly", nil);
        onePickerViewRow.value = @1;
        
        LSPickerViewRow *threePickerViewRow = [LSPickerViewRow new];
        threePickerViewRow.title = NSLocalizedString(@"Every 3 Hours", nil);
        threePickerViewRow.value = @3;
        
        LSPickerViewRow *eightPickerViewRow = [LSPickerViewRow new];
        eightPickerViewRow.title = NSLocalizedString(@"Every 8 Hours", nil);
        eightPickerViewRow.value = @8;
        
        LSPickerViewComponent *pickerViewComponent = [LSPickerViewComponent new];
        pickerViewComponent.rows = [NSMutableArray arrayWithObjects:onePickerViewRow, threePickerViewRow, eightPickerViewRow, nil];
        
        // Create and set up child row model.
        LSPickerViewTableViewRow *pickerViewTableViewRow = [LSPickerViewTableViewRow new];
        pickerViewTableViewRow.dataSource = @[pickerViewComponent];
        
        NSUInteger selectedRow = 0;
        double syncRate = [MAUserSettings sharedUserSettings].syncRate;
        
        if (syncRate == [threePickerViewRow.value doubleValue])
        {
            selectedRow = 1;
        }
        else if (syncRate == [eightPickerViewRow.value doubleValue])
        {
            selectedRow = 2;
        }
        
        [pickerViewTableViewRow selectRow:selectedRow inComponent:0];
        
        // Create and set up row model.
        MAParentPickerViewTableViewRow *tableViewRow = [MAParentPickerViewTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Sync", nil);
        tableViewRow.selectionStyle = UITableViewCellSelectionStyleDefault;
        tableViewRow.childRow = pickerViewTableViewRow;
        tableViewRow.activatedDetailLabelTextColor = [self tintColor];
        tableViewRow.valueChangedBlock = ^(LSTableViewRow *row)
        {
            [MAUserSettings sharedUserSettings].syncRate = [[weakSelf valueFromPickerViewTableViewRow:(LSPickerViewTableViewRow *)row] integerValue];
        };
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    // Calibrate cell.
    /* Disable device calibration.
    {
        // Create and set up row model.
        LSTableViewRow *tableViewRow = [LSTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Calibrate", nil);
        tableViewRow.selectionStyle = UITableViewCellSelectionStyleDefault;
        tableViewRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableViewRow.didSelectBlock = ^(LSTableViewRow *row)
        {
            if ([weakSelf shouldPerformSegueWithIdentifier:kMACalibrateSegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMACalibrateSegueIdentifier sender:weakSelf];
            }
        };
        
        [tableViewSection.rows addObject:tableViewRow];
    }
     */
    
    // Vibrate cell.
    {
        // Create and set up row model.
        LSSwitchTableViewRow *tableViewRow = [LSSwitchTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Vibrate", nil);
        tableViewRow.on = [MAUserSettings sharedUserSettings].vibrate;
        tableViewRow.valueChangedBlock = ^(LSTableViewRow *row)
        {
            [MAUserSettings sharedUserSettings].vibrate = [self boolValueFromSwitchTableViewRow:(LSSwitchTableViewRow *)row];
        };
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    return tableViewSection;
}

- (LSTableViewSection *)aboutTableViewSection
{
    __weak __typeof(self) weakSelf = self;
    
    LSTableViewSection *tableViewSection = [LSTableViewSection new];
    tableViewSection.rows = [NSMutableArray arrayWithCapacity:4];
    
    // Current project cell.
    {
        // Create and set up row model.
        LSTableViewRow *tableViewRow = [LSTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Current Project", nil);
        tableViewRow.detailLabelText = [MAUser currentUser].currentProject.name;
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    // Version cell.
    {
        // Create and set up row model.
        LSTableViewRow *tableViewRow = [LSTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Version", nil);
        tableViewRow.detailLabelText = (__bridge NSString *)(CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey));
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    // Privacy Policy cell.
    {
        // Create and set up row model.
        LSTableViewRow *tableViewRow = [LSTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Privacy Policy", nil);
        tableViewRow.selectionStyle = UITableViewCellSelectionStyleDefault;
        tableViewRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableViewRow.didSelectBlock = ^(LSTableViewRow *row)
        {
            if ([weakSelf shouldPerformSegueWithIdentifier:kMAPrivacyPolicySegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMAPrivacyPolicySegueIdentifier sender:weakSelf];
            }
        };
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    // Terms of Service cell.
    {
        // Create and set up row model.
        LSTableViewRow *tableViewRow = [LSTableViewRow new];
        tableViewRow.labelText = NSLocalizedString(@"Terms of Service", nil);
        tableViewRow.selectionStyle = UITableViewCellSelectionStyleDefault;
        tableViewRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableViewRow.didSelectBlock = ^(LSTableViewRow *row)
        {
            if ([weakSelf shouldPerformSegueWithIdentifier:kMATermsOfServiceSegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMATermsOfServiceSegueIdentifier sender:weakSelf];
            }
        };
        
        [tableViewSection.rows addObject:tableViewRow];
    }
    
    return tableViewSection;
}

#pragma mark -
#pragma mark Helpers

- (UIColor *)tintColor
{
    return self.navigationController.view.tintColor;
}

- (NSNumber *)valueFromPickerViewTableViewRow:(LSPickerViewTableViewRow *)row
{
    NSUInteger componentsIndex = 0;
    NSUInteger rowIndex = [row selectedRowInComponent:componentsIndex];
    
    LSPickerViewComponent *pickerViewComponent = row.dataSource[componentsIndex];
    LSPickerViewRow *pickerViewRow = pickerViewComponent.rows[rowIndex];
    
    return pickerViewRow.value;
}

- (BOOL)boolValueFromSwitchTableViewRow:(LSSwitchTableViewRow *)row
{
    return [row isOn];
}

@end
