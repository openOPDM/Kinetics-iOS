//
//  MASignUpViewController.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/12/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAActionTableViewCell;
@class MATextFieldTableViewCell;

@interface MASignUpViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) UITableViewCell *projectTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *firstNameTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *secondNameTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *emailTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *passwordTableViewCell;
@property (nonatomic) MATextFieldTableViewCell *confirmPasswordTableViewCell;
@property (nonatomic) MAActionTableViewCell *signUpTableViewCell;
@property (nonatomic) MAActionTableViewCell *confirmTableViewCell;

- (IBAction)createAccount:(id)sender;
- (IBAction)confirmAccount:(id)sender;

- (IBAction)unwindToSignUpSegue:(UIStoryboardSegue *)segue;

@end
