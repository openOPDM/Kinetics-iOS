//
//  MASignInViewController.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 1/30/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAActionTableViewCell;
@class MATextFieldTableViewCell;

@interface MASignInViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic) MATextFieldTableViewCell *emailTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *passwordTableViewCell;
@property (nonatomic) MAActionTableViewCell *signInTableViewCell;
@property (nonatomic) MAActionTableViewCell *signUpTableViewCell;

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

- (IBAction)unwindToSignInSegue:(UIStoryboardSegue *)segue;

@end
