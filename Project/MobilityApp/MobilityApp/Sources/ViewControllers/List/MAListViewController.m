//
//  MAListViewController.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/27/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MAListViewController.h"
#import "ExtensionManager.h"

@interface MAListViewController (){
    
    NSArray* list;
    NSIndexPath* selectedCell;
}

@end

@implementation MAListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    list = [[ExtensionManager sharedInstance] extensionListForSelected];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"kListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:[[ExtensionManager sharedInstance]selectedExtensionValue]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedCell = indexPath;
    }
    
    return cell;
  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath != selectedCell) {
        UITableViewCell* theSelectedCell = [tableView cellForRowAtIndexPath:selectedCell];
        theSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
        theCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[ExtensionManager sharedInstance]modifySelecteExtensionWithValue:theCell.textLabel.text];
    }
    
}



@end
