//
//  MASignUpViewController.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/12/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MASignUpViewController.h"

#import "MAAgreementViewController.h"
#import "MAProjectsViewController.h"

#import "MAActionTableViewCell.h"
#import "MAAgreementTableViewFooterView.h"
#import "MATextFieldTableViewCell.h"

#import "MAMessageWebAppResponse.h"

#import "MAWebAppManager+MAAccountManagerTasks.h"

typedef NS_ENUM(NSUInteger, MASignUpAlertViewTag)
{
    MASignUpAlertViewActivateTag
};

static NSString * const kMAProjectCellIdentifier = @"MAProjectCell";
static NSString * const kMAProjectsSegueIdentifier = @"MAProjectsSegue";
static NSString * const kMAPrivacyPolicySegueIdentifier = @"MAPrivacyPolicySegue";
static NSString * const kMATermsOfServiceSegueIdentifier = @"MATermsOfServiceSegue";

@interface MASignUpViewController ()

@property (nonatomic) NSURLSessionTask *signUpURLSessionTask;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSArray *selectedProjects;

@end

@implementation MASignUpViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *actionTableViewCellNib = [UINib nibWithNibName:@"MAActionTableViewCell" bundle:nil];
    UINib *textFieldTableViewCellNib = [UINib nibWithNibName:@"MATextFieldTableViewCell" bundle:nil];
    UINib *agreementTableViewFooterViewNib = [UINib nibWithNibName:@"MAAgreementTableViewFooterView" bundle:nil];
    
    [self.tableView registerNib:actionTableViewCellNib forCellReuseIdentifier:kMAActionTableViewCellIdentifier];
    [self.tableView registerNib:textFieldTableViewCellNib forCellReuseIdentifier:kMATextFieldTableViewCellIdentifier];
    [self.tableView registerNib:agreementTableViewFooterViewNib forHeaderFooterViewReuseIdentifier:kMAAgreementTableViewFooterViewIdentifier];
    
    self.projectTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAProjectCellIdentifier];
    self.projectTableViewCell.textLabel.text = NSLocalizedString(@"Project", nil);
    self.projectTableViewCell.detailTextLabel.text = NSLocalizedString(@"None", nil);
    
    self.firstNameTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATextFieldTableViewCellIdentifier];
    self.firstNameTableViewCell.label.text = NSLocalizedString(@"First Name", nil);
    self.firstNameTableViewCell.textField.text = nil;
    self.firstNameTableViewCell.textField.placeholder = @"John";
    self.firstNameTableViewCell.textField.delegate = self;
    self.firstNameTableViewCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.firstNameTableViewCell.textField.returnKeyType = UIReturnKeyNext;
    
    self.secondNameTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATextFieldTableViewCellIdentifier];
    self.secondNameTableViewCell.label.text = NSLocalizedString(@"Last Name", nil);
    self.secondNameTableViewCell.textField.text = nil;
    self.secondNameTableViewCell.textField.placeholder = @"Appleseed";
    self.secondNameTableViewCell.textField.delegate = self;
    self.secondNameTableViewCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.secondNameTableViewCell.textField.returnKeyType = UIReturnKeyNext;
    
    self.emailTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATextFieldTableViewCellIdentifier];
    self.emailTableViewCell.label.text = NSLocalizedString(@"Email", nil);
    self.emailTableViewCell.textField.text = nil;
    self.emailTableViewCell.textField.placeholder = @"name@example.com";
    self.emailTableViewCell.textField.delegate = self;
    self.emailTableViewCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTableViewCell.textField.returnKeyType = UIReturnKeyNext;
    
    self.passwordTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATextFieldTableViewCellIdentifier];
    self.passwordTableViewCell.label.text = NSLocalizedString(@"Password", nil);
    self.passwordTableViewCell.textField.text = nil;
    self.passwordTableViewCell.textField.placeholder = @"Required";
    self.passwordTableViewCell.textField.delegate = self;
    self.passwordTableViewCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTableViewCell.textField.returnKeyType = UIReturnKeyNext;
    self.passwordTableViewCell.textField.secureTextEntry = YES;
    
    self.confirmPasswordTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMATextFieldTableViewCellIdentifier];
    self.confirmPasswordTableViewCell.label.text = NSLocalizedString(@"Confirm", nil);
    self.confirmPasswordTableViewCell.textField.text = nil;
    self.confirmPasswordTableViewCell.textField.placeholder = @"Required";
    self.confirmPasswordTableViewCell.textField.delegate = self;
    self.confirmPasswordTableViewCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.confirmPasswordTableViewCell.textField.returnKeyType = UIReturnKeyDone;
    self.confirmPasswordTableViewCell.textField.secureTextEntry = YES;
    
    self.signUpTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAActionTableViewCellIdentifier];
    self.signUpTableViewCell.label.text = NSLocalizedString(@"Sign Up", nil);
    
    self.confirmTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAActionTableViewCellIdentifier];
    self.confirmTableViewCell.label.text = NSLocalizedString(@"Enter Code", nil);
    
    self.dataSource = @[@[self.projectTableViewCell],
                        @[self.firstNameTableViewCell, self.secondNameTableViewCell, self.emailTableViewCell],
                        @[self.passwordTableViewCell, self.confirmPasswordTableViewCell],
                        @[self.signUpTableViewCell],
                        @[self.confirmTableViewCell]];
    
    self.selectedProjects = [NSArray array];
}

#pragma mark -
#pragma mark Overridden Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMAProjectsSegueIdentifier])
    {
        MAProjectsViewController *viewController = segue.destinationViewController;
        viewController.didSelectProjectBlock = ^(NSArray *selectedProjects)
        {
            self.selectedProjects = selectedProjects;
            self.projectTableViewCell.detailTextLabel.text = [[self.selectedProjects valueForKey:@"name"] componentsJoinedByString:@", "];
        };
    }
    else if ([segue.identifier isEqualToString:kMAPrivacyPolicySegueIdentifier])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MAAgreementViewController *viewController = (MAAgreementViewController *)navigationController.topViewController;
        viewController.type = MAAgreementPrivacyPolicyType;
    }
    else if ([segue.identifier isEqualToString:kMATermsOfServiceSegueIdentifier])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MAAgreementViewController *viewController = (MAAgreementViewController *)navigationController.topViewController;
        viewController.type = MAAgreementTermsOfServiceType;
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)createAccount:(id)sender
{
    if ([self validateCreateAccountForm])
    {
        [self createUserWithEmail:self.emailTableViewCell.textField.text
                        firstName:self.firstNameTableViewCell.textField.text
                       secondName:self.secondNameTableViewCell.textField.text
                         passHash:self.passwordTableViewCell.textField.text
                          project:[self.selectedProjects valueForKey:@"identifier"]];
    }
}

- (IBAction)confirmAccount:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter Code", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    alertView.tag = MASignUpAlertViewActivateTag;
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *loginTextField = [alertView textFieldAtIndex:0];
    loginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    loginTextField.placeholder = NSLocalizedString(@"name@example.com", @"");
    
    UITextField *passwordTextField = [alertView textFieldAtIndex:1];
    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.placeholder = NSLocalizedString(@"Confirmation Code", @"");
    
    [alertView show];
}

- (IBAction)unwindToSignUpSegue:(UIStoryboardSegue *)segue
{
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = UITableViewAutomaticDimension;
    
    if (section == 2)
    {
        height = kMAAgreementTableViewFooterViewHeight;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 2)
    {
        __weak __typeof(self) weakSelf = self;
        
        MAAgreementTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMAAgreementTableViewFooterViewIdentifier];
        footerView.didSelectPrivacyPolicyBlock = ^(void)
        {
            if ([weakSelf shouldPerformSegueWithIdentifier:kMAPrivacyPolicySegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMAPrivacyPolicySegueIdentifier sender:weakSelf];
            }
        };
        footerView.didSelectTermsOfServiceBlock = ^(void)
        {
            if ([weakSelf shouldPerformSegueWithIdentifier:kMATermsOfServiceSegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMATermsOfServiceSegueIdentifier sender:weakSelf];
            }
        };
        
        view = footerView;
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MATextFieldTableViewCell class]])
    {
        [((MATextFieldTableViewCell *)cell).textField becomeFirstResponder];
    }
    else if (cell == self.signUpTableViewCell)
    {
        [self createAccount:cell];
    }
    else if (cell == self.confirmTableViewCell)
    {
        [self confirmAccount:cell];
    }
}

#pragma mark -
#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MASignUpAlertViewActivateTag)
    {
        if (buttonIndex == 1)
        {
            UITextField *loginTextField = [alertView textFieldAtIndex:0];
            UITextField *passwordTextField = [alertView textFieldAtIndex:1];
            
            if (![self ma_validateAccountFormEmail:loginTextField.text]) { return; }
            if (![self ma_validateAccountFormString:passwordTextField.text]) { return; }
            
            [self confirmCreateAccountWithConfirmationCode:passwordTextField.text email:loginTextField.text];
        }
    }
}

#pragma mark -
#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameTableViewCell.textField)
    {
        [self.secondNameTableViewCell.textField becomeFirstResponder];
    }
    else if (textField == self.secondNameTableViewCell.textField)
    {
        [self.emailTableViewCell.textField becomeFirstResponder];
    }
    if (textField == self.emailTableViewCell.textField)
    {
        [self.passwordTableViewCell.textField becomeFirstResponder];
    }
    else if (textField == self.passwordTableViewCell.textField)
    {
        [self.confirmPasswordTableViewCell.textField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTableViewCell.textField)
    {
        [textField resignFirstResponder];
        [self createAccount:textField];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Working with WebApp

- (void)createUserWithEmail:(NSString *)email
                  firstName:(NSString *)firstName
                 secondName:(NSString *)secondName
                   passHash:(NSString *)passHash
                    project:(NSArray *)project
{
    [self.signUpURLSessionTask cancel];
    
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MAMessageWebAppResponse *, NSError *) = ^(MAMessageWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error] && [response.message isEqualToString:kMAWebAppResponseParameterOKValue])
        {
            NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Confirmation Code Was Sent to %@", nil), email];
            
            [weakSelf ma_showAlertWithTitle:title message:nil];
        }
    };
    
    self.signUpURLSessionTask = [[MAWebAppManager sharedManager] createUserWithEmail:email
                                                                           firstName:firstName
                                                                          secondName:secondName
                                                                            passHash:passHash
                                                                             project:project
                                                                   completionHandler:completionHandler];
}

- (void)confirmCreateAccountWithConfirmationCode:(NSString *)confirmationCode email:(NSString *)email
{
    [self.signUpURLSessionTask cancel];
    
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MAMessageWebAppResponse *, NSError *) = ^(MAMessageWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error] && [response.message isEqualToString:kMAWebAppResponseParameterOKValue])
        {
            NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Account for %@ Created Successfully", nil), email];
            
            [weakSelf ma_showAlertWithTitle:title message:nil];
        }
    };
    
    self.signUpURLSessionTask = [[MAWebAppManager sharedManager] confirmCreateAccountWithConfirmationCode:confirmationCode
                                                                                                    email:email
                                                                                        completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Helpers

- (BOOL)validateCreateAccountForm
{
    if (![self ma_validateAccountFormString:self.firstNameTableViewCell.textField.text]) { return NO; }
    if (![self ma_validateAccountFormString:self.secondNameTableViewCell.textField.text]) { return NO; }
    if (![self ma_validateAccountFormEmail:self.emailTableViewCell.textField.text]) { return NO; }
    if (![self ma_validateAccountFormString:self.firstNameTableViewCell.textField.text]) { return NO; }
    if (![self ma_validateAccountFormPassword:self.passwordTableViewCell.textField.text
                              confirmPassword:self.confirmPasswordTableViewCell.textField.text]) { return NO; }
    
    return YES;
}

@end
