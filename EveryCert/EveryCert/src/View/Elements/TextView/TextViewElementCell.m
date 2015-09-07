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
    __weak IBOutlet UILabel    *_titleLabel;
    __weak IBOutlet UILabel    *_charLimitLabel;
    __weak IBOutlet UITextView *_textView;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _titleLabel.text     = elementModel.label;
    _textView.text       = elementModel.dataValue;
    _charLimitLabel.text = [@(elementModel.maxCharLimit) stringValue];
}

#pragma mark UITextViewDelegate Methods

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.elementModel.dataValue = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *updatedString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
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

@end
