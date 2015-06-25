//
//  MASignInViewController.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 1/30/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MASignInViewController.h"

#import "MAProjectsViewController.h"

#import "MAActionTableViewCell.h"
#import "MATextFieldTableViewCell.h"

#import "MAProject.h"
#import "MAProjectsWebAppResponse.h"
#import "MASessionTokenWebAppResponse.h"
#import "MAUser.h"

#import "MAWebAppManager+MAAccountManagerTasks.h"

static NSString * const kMASignInSegueIdentifier = @"MASignInSegue";
static NSString * const kMASignUpSegueIdentifier = @"MASignUpSegue";
static NSString * const kMAProjectsSegueIdentifier = @"MAProjectsSegue";

@interface MASignInViewController ()

@property (nonatomic) NSURLSessionTask *signInURLSessionTask;

@property (nonatomic) NSArray *dataSource;

@end

@implementation MASignInViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MAActionTableViewCell" bundle:nil] forCellReuseIdentifier:kMAActionTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MATextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:kMATextFieldTableViewCellIdentifier];
    
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
    self.passwordTableViewCell.textField.returnKeyType = UIReturnKeyDone;
    self.passwordTableViewCell.textField.secureTextEntry = YES;
    
    self.signInTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAActionTableViewCellIdentifier];
    self.signInTableViewCell.label.text = NSLocalizedString(@"Sign In", nil);
    
    self.signUpTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kMAActionTableViewCellIdentifier];
    self.signUpTableViewCell.label.text = NSLocalizedString(@"Sign Up", nil);
    
    self.dataSource = @[@[self.emailTableViewCell, self.passwordTableViewCell], @[self.signInTableViewCell], @[self.signUpTableViewCell]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MAUser *user = [MAUser currentUser];
    
    self.emailTableViewCell.textField.text = user.email;
    self.passwordTableViewCell.textField.text = user.password;
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
            if ([selectedProjects count] == 1)
            {
                MAUser *user = [MAUser currentUser];
                user.currentProject = [selectedProjects firstObject];
                
                [self loginWithEmail:self.emailTableViewCell.textField.text
                            passHash:self.passwordTableViewCell.textField.text
                             project:user.currentProject.identifier];
            }
        };
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)signIn:(id)sender
{
    if ([self validateAccountForm])
    {
        [self authenticateWithEmail:self.emailTableViewCell.textField.text passHash:self.passwordTableViewCell.textField.text];
    }
}

- (IBAction)signUp:(id)sender
{
    if ([self shouldPerformSegueWithIdentifier:kMASignUpSegueIdentifier sender:sender])
    {
        [self performSegueWithIdentifier:kMASignUpSegueIdentifier sender:sender];
    }
}

- (IBAction)unwindToSignInSegue:(UIStoryboardSegue *)segue
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MATextFieldTableViewCell class]])
    {
        [((MATextFieldTableViewCell *)cell).textField becomeFirstResponder];
    }
    else if (cell == self.signInTableViewCell)
    {
        [self signIn:cell];
    }
    else if (cell == self.signUpTableViewCell)
    {
        [self signUp:cell];
    }
}

#pragma mark -
#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTableViewCell.textField)
    {
        [self.passwordTableViewCell.textField becomeFirstResponder];
    }
    else if (textField == self.passwordTableViewCell.textField)
    {
        [textField resignFirstResponder];
        [self signIn:textField];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Working with WebApp

- (void)loginWithEmail:(NSString *)email passHash:(NSString *)passHash project:(NSNumber *)project
{
    [self.signInURLSessionTask cancel];
    
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MASessionTokenWebAppResponse *, NSError *) = ^(MASessionTokenWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error])
        {
            MAUser *user = [MAUser currentUser];
            user.email = email;
            user.password = passHash;
            user.sessionToken = response.sessionToken;
            
            if ([weakSelf shouldPerformSegueWithIdentifier:kMASignInSegueIdentifier sender:weakSelf])
            {
                [weakSelf performSegueWithIdentifier:kMASignInSegueIdentifier sender:weakSelf];
            }
        }
    };
    
    self.signInURLSessionTask = [[MAWebAppManager sharedManager] loginWithEmail:email passHash:passHash project:project completionHandler:completionHandler];
}

- (void)authenticateWithEmail:(NSString *)email passHash:(NSString *)passHash
{
    [self.signInURLSessionTask cancel];
    
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MAProjectsWebAppResponse *, NSError *) = ^(MAProjectsWebAppResponse *response, NSError *error)
    {
        if ([weakSelf ma_validateResponse:response error:error])
        {
            MAUser *user = [MAUser currentUser];
            user.email = email;
            user.password = passHash;
            user.projects = response.projects;
            
            if ([user.projects count] == 1)
            {
                user.currentProject = [response.projects firstObject];
                
                [weakSelf loginWithEmail:email passHash:passHash project:user.currentProject.identifier];
            }
            else
            {
                if ([weakSelf shouldPerformSegueWithIdentifier:kMAProjectsSegueIdentifier sender:weakSelf])
                {
                    [weakSelf performSegueWithIdentifier:kMAProjectsSegueIdentifier sender:weakSelf];
                }
            }
        }
    };
    
    self.signInURLSessionTask = [[MAWebAppManager sharedManager] authenticateWithEmail:email passHash:passHash completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Helpers

- (BOOL)validateAccountForm
{
    if (![self ma_validateAccountFormEmail:self.emailTableViewCell.textField.text]) { return NO; }
    if (![self ma_validateAccountFormString:self.passwordTableViewCell.textField.text]) { return NO; }
    
    return YES;
}

@end
