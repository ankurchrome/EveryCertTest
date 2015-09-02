//
//  TextViewElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TextViewElementCell.h"

@implementation TextViewElementCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_charLimitLabel;
    NSInteger maxCharLimit;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TextViewElementCell *)initWithModel:(ElementModel *)formElement
{
    [self fillWithData:formElement.dataValue];
    _titleLabel.text = formElement.label;
    _charLimitLabel.text = [@(formElement.maxCharLimit) stringValue];
    maxCharLimit   = [_charLimitLabel.text integerValue];
    _textView.delegate = self;
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    if (data && [data isKindOfClass:[NSString class]])
    {
        _textView.text = data;
    }
    
    FUNCTION_END;
}

#pragma mark UITextFieldDelegate Methods

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.elementModel.dataValue = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *updatedString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
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
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
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
    [_textView resignFirstResponder];
}

- (void)cancelKeyBoard:(UIBarButtonItem *)sender
{
    [_textView resignFirstResponder];
}

@end
