//
//  LSTableViewController.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/11/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTableViewController.h"

#import "LSPickerViewTableViewCell.h"
#import "LSSwitchTableViewCell.h"
#import "LSTableViewCell.h"
#import "LSTextFieldTableViewCell.h"

#import "LSTableViewRow.h"
#import "LSTableViewSection.h"

// ********************************************************************************************************************************************************** //

@interface LSTableViewController () <LSTableViewCellDelegate>

@property (nonatomic) NSIndexPath *activeIndexPath;

@end

// ********************************************************************************************************************************************************** //

@implementation LSTableViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[LSSwitchTableViewCell class] forCellReuseIdentifier:kLSSwitchTableViewCellID];
    [self.tableView registerClass:[LSPickerViewTableViewCell class] forCellReuseIdentifier:kLSPickerViewTableViewCellID];
    [self.tableView registerClass:[LSTableViewCell class] forCellReuseIdentifier:kLSTableViewCellID];
    [self.tableView registerClass:[LSTextFieldTableViewCell class] forCellReuseIdentifier:kLSTextFieldTableViewCellID];
}

#pragma mark -
#pragma mark Methods

- (NSIndexPath *)indexPathForActiveRow
{
    return self.activeIndexPath;
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LSTableViewSection *tableViewSection = self.dataSource[section];
    return [tableViewSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTableViewRow *tableViewRow = [self tableViewRowForRowAtIndexPath:indexPath];
    
    LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewRow.reuseIdentifier forIndexPath:indexPath];
    cell.row = tableViewRow;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LSTableViewSection *tableViewSection = self.dataSource[section];
    return tableViewSection.titleForHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    LSTableViewSection *tableViewSection = self.dataSource[section];
    return tableViewSection.titleForFooter;
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTableViewRow *tableViewRow = [self tableViewRowForRowAtIndexPath:indexPath];
    return tableViewRow.height != nil ? [tableViewRow.height doubleValue] : UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark <LKDTableViewCellDelegate>

- (void)tableViewCellDidBecomeActive:(LSTableViewCell *)cell
{
    NSIndexPath *oldIndexPath = self.activeIndexPath;
    NSIndexPath *newIndexPath = [self.tableView indexPathForCell:cell];
    
    LSTableViewRow *oldTableViewRow = [self tableViewRowForRowAtIndexPath:oldIndexPath];
    LSTableViewRow *newTableViewRow = [self tableViewRowForRowAtIndexPath:newIndexPath];
    
    if (newTableViewRow.childRow == nil && oldTableViewRow.childRow != nil)
    {
        self.activeIndexPath = nil;
        oldTableViewRow.activated = NO;
        self.activeIndexPath = oldIndexPath;
        
        [self toggleChildRowForRowAtIndexPath:oldIndexPath];
        
        self.activeIndexPath = newIndexPath;
    }
    else if (newTableViewRow.childRow != nil)
    {
        self.activeIndexPath = nil;
        oldTableViewRow.activated = NO;
        self.activeIndexPath = oldTableViewRow.childRow != nil ? oldIndexPath : nil;
        
        [self toggleChildRowForRowAtIndexPath:newIndexPath];
    }
    else
    {
        self.activeIndexPath = nil;
        oldTableViewRow.activated = NO;
        self.activeIndexPath = newIndexPath;
    }
}

- (void)tableViewCellDidDeactivate:(LSTableViewCell *)cell
{
    LSTableViewRow *tableViewRow = [self tableViewRowForRowAtIndexPath:self.activeIndexPath];
    
    if (tableViewRow != nil)
    {
        if (tableViewRow.childRow != nil)
        {
            [self toggleChildRowForRowAtIndexPath:self.activeIndexPath];
        }
        
        self.activeIndexPath = nil;
    }
}

#pragma mark -
#pragma mark Working With Data Source

- (LSTableViewRow *)tableViewRowForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil)
    {
        return nil;
    }
    
    LSTableViewSection *tableViewSection = self.dataSource[indexPath.section];
    LSTableViewRow *tableViewRow = tableViewSection.rows[indexPath.row];
    
    return tableViewRow;
}

#pragma mark -
#pragma mark Managing Child Cell

- (void)toggleChildRowForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil)
    {
        return;
    }
    
    [self.tableView beginUpdates];
    
    if (self.activeIndexPath != nil)
    {
        // Associated child row is available.
        [self deleteChildRowForRowAtIndexPath:self.activeIndexPath];
        
        if (self.activeIndexPath.section == indexPath.section)
        {
            if (self.activeIndexPath.row == indexPath.row)
            {
                // Has associated child row.
                self.activeIndexPath = nil;
            }
            else
            {
                // Hasn't associated child row.
                self.activeIndexPath = self.activeIndexPath.row < indexPath.row
                ? [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]
                : indexPath;
                [self insertChildRowForRowAtIndexPath:self.activeIndexPath];
            }
        }
        else
        {
            // Hasn't associated child row.
            self.activeIndexPath = indexPath;
            [self insertChildRowForRowAtIndexPath:self.activeIndexPath];
        }
    }
    else
    {
        // Associated child row is not available.
        self.activeIndexPath = indexPath;
        [self insertChildRowForRowAtIndexPath:self.activeIndexPath];
    }
    
    [self.tableView endUpdates];
    
    // Scroll to a new associated child row.
    [self scrollToChildRowForRowAtIndexPath:self.activeIndexPath];
}

- (void)insertChildRowForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTableViewSection *tableViewSection = self.dataSource[indexPath.section];
    LSTableViewRow *tableViewRow = tableViewSection.rows[indexPath.row];
    
    // Insert to child index path.
    NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    [tableViewSection.rows insertObject:tableViewRow.childRow atIndex:childIndexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[childIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteChildRowForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTableViewSection *sectionModel = self.dataSource[indexPath.section];
    
    // Remove from child index path.
    NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    [sectionModel.rows removeObjectAtIndex:childIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[childIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)scrollToChildRowForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil)
    {
        NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView scrollToRowAtIndexPath:childIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

@end
