//
//  LSTextFieldTableViewCell.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/10/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSTextFieldTableViewCell.h"

#import "LSTextFieldTableViewRow.h"

// ********************************************************************************************************************************************************** //

NSString * const kLSTextFieldTableViewCellID = @"LSTextFieldCell";

// ********************************************************************************************************************************************************** //

@interface LSTextFieldTableViewCell ()

@property (nonatomic) LSTextFieldTableViewRow *textFieldTableViewRow;

@end

// ********************************************************************************************************************************************************** //

@implementation LSTextFieldTableViewCell

#pragma mark -
#pragma mark Overridden Accessors

- (void)setRow:(LSTableViewRow *)row
{
    [super setRow:row];
    
    self.textField.text = self.textFieldTableViewRow.text;
    self.textField.textAlignment = self.textFieldTableViewRow.textAlignment;
    self.textField.placeholder = self.textFieldTableViewRow.placeholder;
    
    self.textField.keyboardType = self.textFieldTableViewRow.keyboardType;
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)canBecomeActive
{
    return YES;
}

- (void)didActivate
{
    [super didActivate];
    
    if (![self.textField isFirstResponder])
    {
        [self.textField becomeFirstResponder];
    }
}

- (void)didDeactivate
{
    [super didDeactivate];
    
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark Accessors

- (UITextField *)textField
{
    if (![self.accessoryView isKindOfClass:[UITextField class]])
    {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 44.0)];
        textField.delegate = self;
        
        [textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.accessoryView = textField;
    }
    
    return (UITextField *)self.accessoryView;
}

#pragma mark -
#pragma mark <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldTableViewRow.activated = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldTableViewRow.activated = NO;
}

#pragma mark -
#pragma mark Private Accessors

- (LSTextFieldTableViewRow *)textFieldTableViewRow
{
    NSAssert(self.row == nil || [self.row isKindOfClass:[LSTextFieldTableViewRow class]], @"Wrong type of row");
    return (LSTextFieldTableViewRow *)self.row;
}

#pragma mark -
#pragma mark Private Actions

- (void)valueChanged:(id)sender
{
    self.textFieldTableViewRow.text = [sender text];
    
    if (self.textFieldTableViewRow.valueChangedBlock != nil)
    {
        self.textFieldTableViewRow.valueChangedBlock(self.textFieldTableViewRow);
    }
}

@end
