//
//  MAProjectsViewController.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/17/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAProjectsViewController : UITableViewController

@property (nonatomic) NSArray *projects;
@property (nonatomic, copy) void (^didSelectProjectBlock)(NSArray *selectedProjects);

- (IBAction)refresh:(id)sender;

@end
