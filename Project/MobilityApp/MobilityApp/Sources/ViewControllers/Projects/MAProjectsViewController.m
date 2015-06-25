//
//  MAProjectsViewController.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/17/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MAProjectsViewController.h"

#import "MAProject.h"
#import "MAProjectsWebAppResponse.h"

#import "MAWebAppManager+MAProjectManagerTasks.h"

static NSString * const kMAProjectCellIdentifier = @"MAProjectCell";

@interface MAProjectsViewController ()

@property (nonatomic) NSMutableIndexSet *indexSet;

@end

@implementation MAProjectsViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh:self];
}

#pragma mark -
#pragma mark Actions

- (IBAction)refresh:(id)sender
{
    [self getProjectInfoList];
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAProject *project = [self.projects objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMAProjectCellIdentifier];
    cell.textLabel.text = project.name;
    cell.accessoryType = [self.indexSet containsIndex:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.indexSet containsIndex:indexPath.row])
    {
        [self.indexSet removeIndex:indexPath.row];
    }
    else
    {
        [self.indexSet addIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = [self.indexSet containsIndex:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    if (self.didSelectProjectBlock != nil)
    {
        self.didSelectProjectBlock([self.projects objectsAtIndexes:self.indexSet]);
    }
}

#pragma mark -
#pragma mark Working with WebApp

- (void)getProjectInfoList
{
    void (^completionHandler)(MAProjectsWebAppResponse *, NSError *) = ^(MAProjectsWebAppResponse *response, NSError *error)
    {
        if ([self ma_validateResponse:response error:error])
        {
            self.projects = response.projects;
            self.indexSet = [NSMutableIndexSet indexSet];
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    };
    
    [[MAWebAppManager sharedManager] getProjectInfoListWithCompletionHandler:completionHandler];
}

@end
