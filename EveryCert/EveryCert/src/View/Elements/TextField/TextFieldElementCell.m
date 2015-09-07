//
//  TextFieldElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TextFieldElementCell.h"

@implementation TextFieldElementCell
{
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UILabel     *_charLimitLabel;
    __weak IBOutlet UILabel     *_textLabel;
    __weak IBOutlet UIButton    *_defaultButton;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];

    _textLabel.text = elementModel.label;
    _textField.text = elementModel.dataValue;
    _charLimitLabel.text = [@(elementModel.maxCharLimit) stringValue];
    
    [_textLabel sizeToFit];
}

#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.elementModel.dataValue = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger remainingChars = self.elementModel.maxCharLimit;
    
    if (updatedString && self.elementModel.maxCharLimit > 0)
    {
        remainingChars = self.elementModel.maxCharLimit - updatedString.length;
        
        if (remainingChars >= 0)
        {
            _charLimitLabel.text = @(remainingChars).stringValue;
        }
    }
    
    if (remainingChars < 0)
    {
        return NO;
    }
    
    self.elementModel.dataValue = updatedString;
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)onClickDefaultButton:(UIButton *)button
{
    _textField.text = button.titleLabel.text;
    self.elementModel.dataValue = _textField.text;
}

@end
