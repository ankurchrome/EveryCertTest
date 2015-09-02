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
    __weak IBOutlet UILabel *_charLimitLabel;
    __weak IBOutlet UIButton *_defaultButton;
    __weak IBOutlet UILabel *_textLabel;
    NSString *_labelLenght;
    
    
    NSInteger maxCharLimit;
}

- (void)awakeFromNib {
    // Initialization code
    _textField.delegate = self;
    maxCharLimit   = [_charLimitLabel.text integerValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (TextFieldElementCell *)initWithModel:(ElementModel *)formElement
{
    
    //self = [super initWithModel:formElement];
    //[self fillWithData:formElement.dataValue];
    _textLabel.text = formElement.label;
    _textField.text = EMPTY_STRING;
    _charLimitLabel.text = [@(formElement.maxCharLimit) stringValue];
    [_textLabel sizeToFit];
    _labelLenght = formElement.label;
    return self;
}

- (void)initWithData:(NSString *)string
{
    _textLabel.text = string;
    _defaultButton.hidden = YES;
    [_textLabel sizeToFit];
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    if (data && [data isKindOfClass:[NSString class]])
    {
        _textField.text = data;
    }
    
    FUNCTION_END;
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
    
    NSInteger remainingChars = maxCharLimit;
    
    if (updatedString && maxCharLimit > 0)
    {
        remainingChars = maxCharLimit - updatedString.length;
        
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

- (void)resignKeyboard
{
    if (_textField.isFirstResponder) {
        [_textField resignFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KeyboardWillResignNotification
                                                  object:nil];
}

- (void)doneChanges:(id)sender
{
    [_textField resignFirstResponder];
}

- (void)cancelKeyBoard:(UIBarButtonItem *)sender
{
    [_textField resignFirstResponder];
}

#pragma mark - Selectors

// When user click on Default Button
- (void)onClickDefaultTextButton:(UIButton *)buttton
{
    [self fillWithData: self.elementModel.dataValue];
}

#pragma mark - IBActions

- (IBAction)onClickDefaultButton:(UIButton *)button {
    _textField.text = button.titleLabel.text;
}

@end
