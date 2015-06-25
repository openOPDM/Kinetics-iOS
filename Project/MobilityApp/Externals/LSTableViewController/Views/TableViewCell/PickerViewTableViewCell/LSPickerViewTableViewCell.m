//
//  LSPickerViewTableViewCell.m
//  Lohika Systems, Inc.
//
//  Created by Vitaly Yurchenko on 2/11/14.
//  Copyright (c) 2014 Lohika Systems, Inc. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "LSPickerViewTableViewCell.h"

#import "LSPickerViewComponent.h"
#import "LSPickerViewRow.h"
#import "LSPickerViewTableViewRow.h"

// ********************************************************************************************************************************************************** //

NSString * const kLSPickerViewTableViewCellID = @"LSPickerViewCell";

// ********************************************************************************************************************************************************** //

@interface LSPickerViewTableViewCell ()

@property (nonatomic, readonly) LSPickerViewTableViewRow *pickerViewTableViewRow;

@end

// ********************************************************************************************************************************************************** //

@implementation LSPickerViewTableViewCell

#pragma mark -
#pragma mark Object Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        [self.contentView addSubview:_pickerView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Overridden Accessors

- (void)setRow:(LSTableViewRow *)row
{
    [super setRow:row];
    
    [self.pickerView reloadAllComponents];
    
    for (NSInteger componentIndex = 0; componentIndex < self.pickerView.numberOfComponents; componentIndex++)
    {
        NSInteger rowIndex = [self.pickerViewTableViewRow selectedRowInComponent:componentIndex];
        [self.pickerView selectRow:rowIndex inComponent:componentIndex animated:NO];
    }
}

#pragma mark -
#pragma mark Methods

+ (CGFloat)height
{
    static CGFloat height = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
    {
        UIPickerView *pickerView = [UIPickerView new];
        height = CGRectGetHeight(pickerView.bounds);
    });
    
    return height;
}

#pragma mark -
#pragma mark <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerViewTableViewRow.dataSource count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    LSPickerViewComponent *sectionModel = self.pickerViewTableViewRow.dataSource[component];
    return [sectionModel.rows count];
}

#pragma mark -
#pragma mark <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LSPickerViewComponent *pickerViewComponent = self.pickerViewTableViewRow.dataSource[component];
    LSPickerViewRow *pickerViewRow = pickerViewComponent.rows[row];
    return pickerViewRow.title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.pickerViewTableViewRow selectRow:row inComponent:component];
    
    if (self.pickerViewTableViewRow.valueChangedBlock != nil)
    {
        self.pickerViewTableViewRow.valueChangedBlock(self.pickerViewTableViewRow);
    }
}

#pragma mark -
#pragma mark Private Accessors

- (LSPickerViewTableViewRow *)pickerViewTableViewRow
{
    NSAssert(self.row == nil || [self.row isKindOfClass:[LSPickerViewTableViewRow class]], @"Wrong type of row");
    return (LSPickerViewTableViewRow *)self.row;
}

@end
