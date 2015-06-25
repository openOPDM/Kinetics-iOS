//
//  MATestSessionRawDataViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MATestSessionRawDataViewController.h"

#import "MATestSessionRawData.h"

static NSString * const kMARAWDataCellIdentifier = @"MARAWDataCell";

static NSString * const kMATestSessionRawDataAREAValue = @"MATestSessionRawDataAREAValue";
static NSString * const kMATestSessionRawDataRMSValue = @"MATestSessionRawDataRMSValue";
static NSString * const kMATestSessionRawDataValuesValue = @"MATestSessionRawDataValuesValue";
static NSString * const kMATestSessionRawDataClientSystemInfoValue = @"MATestSessionRawDataClientSystemInfoValue";

@interface MATestSessionRawDataViewController ()

@property (nonatomic) NSDictionary *sectionsMap;

@end

@implementation MATestSessionRawDataViewController

#pragma mark -
#pragma mar Actions

- (IBAction)mail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSData *attachment = [self dataFromRawData];
        
        if (attachment != nil)
        {
            MFMailComposeViewController *mailComposerViewController = [[MFMailComposeViewController alloc] init];
            mailComposerViewController.mailComposeDelegate = self;
            
            [mailComposerViewController setSubject:NSLocalizedString(@"Mobility RAW Data", nil)];
            [mailComposerViewController addAttachmentData:attachment mimeType:@"text/plain" fileName:@"RAWData"];
            
            [self presentViewController:mailComposerViewController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't Create Mobility RAW Data Report", @"")
                                                                message:NSLocalizedString(@"Please try again later.", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't Send Email", @"")
                                                            message:NSLocalizedString(@"Add an email account in Settings, then try again.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        
        [alertView show];
    }
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataAREAValue])
    {
        numberOfRows = 1;
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataRMSValue])
    {
        numberOfRows = 1;
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataValuesValue])
    {
        numberOfRows = [self.testRawData valueCount];
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataClientSystemInfoValue])
    {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMARAWDataCellIdentifier forIndexPath:indexPath];
    
    if ([self.sectionsMap[@(indexPath.section)] isEqualToString:kMATestSessionRawDataAREAValue])
    {
        cell.textLabel.text = self.testRawData.area;
        cell.detailTextLabel.text = nil;
    }
    else if ([self.sectionsMap[@(indexPath.section)] isEqualToString:kMATestSessionRawDataRMSValue])
    {
        cell.textLabel.text = self.testRawData.rms;
        cell.detailTextLabel.text = nil;
    }
    else if ([self.sectionsMap[@(indexPath.section)] isEqualToString:kMATestSessionRawDataValuesValue])
    {
        NSString *x = nil;
        NSString *y = nil;
        NSString *z = nil;
        NSString *t = nil;
        
        [self.testRawData getXValue:&x yValue:&y zValue:&z tValue:&t atIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"X: %.3f Y: %.3f Z: %.3f", [x doubleValue], [y doubleValue], [z doubleValue]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"T: %.3f", [t doubleValue]];
    }
    else if ([self.sectionsMap[@(indexPath.section)] isEqualToString:kMATestSessionRawDataClientSystemInfoValue])
    {
        cell.textLabel.text = self.testRawData.clientSystemInfo;
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    NSMutableDictionary *mutableSectionsMap = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if (self.testRawData.area != nil)
    {
        mutableSectionsMap[@(numberOfSections++)] = kMATestSessionRawDataAREAValue;
    }
    
    if (self.testRawData.rms != nil)
    {
        mutableSectionsMap[@(numberOfSections++)] = kMATestSessionRawDataRMSValue;
    }
    
    if (self.testRawData.values != nil)
    {
        mutableSectionsMap[@(numberOfSections++)] = kMATestSessionRawDataValuesValue;
    }
    
    if (self.testRawData.clientSystemInfo != nil)
    {
        mutableSectionsMap[@(numberOfSections++)] = kMATestSessionRawDataClientSystemInfoValue;
    }
    
    self.sectionsMap = [mutableSectionsMap copy];
    
    NSAssert(numberOfSections == (NSInteger)[self.sectionsMap count], @"Wrong number of sections in table view.");
    
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataAREAValue])
    {
        title = NSLocalizedString(@"AREA", nil);
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataRMSValue])
    {
        title = NSLocalizedString(@"RMS", nil);
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataValuesValue])
    {
        title = NSLocalizedString(@"Values", nil);
    }
    else if ([self.sectionsMap[@(section)] isEqualToString:kMATestSessionRawDataClientSystemInfoValue])
    {
        title = NSLocalizedString(@"Client System Info", nil);
    }
    
    return title;
}

#pragma mark -
#pragma mark <MFMailComposeViewControllerDelegate>

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Private Methods

- (NSData *)dataFromRawData
{
    NSString *x = nil;
    NSString *y = nil;
    NSString *z = nil;
    NSString *t = nil;
    NSMutableString *rawDataString = [NSMutableString string];
    
    for (NSUInteger index = 0; index < [self.testRawData valueCount]; index++)
    {
        [self.testRawData getXValue:&x yValue:&y zValue:&z tValue:&t atIndex:index];
        
        [rawDataString appendFormat:@"%.3f %.3f %.3f %.3f\n", [x doubleValue], [y doubleValue], [z doubleValue], [t doubleValue]];
    }
    
    return [rawDataString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
