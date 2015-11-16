//
//  TextFieldElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TextFieldElementCell.h"
#import "CertViewController.h"

#define TEXTFIELD_TRAILING_CONSTANT_DEFAULT 5

@implementation TextFieldElementCell
{
    __weak IBOutlet UILabel     *_charLimitLabel;
    __weak IBOutlet UILabel     *_textLabel;
    __weak IBOutlet UIButton    *_defaultButton;
    IBOutlet NSLayoutConstraint *_titleLabelLeadingConstraint;
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
    
    NSString *defaultText = elementModel.printedTextFormat[kPdfFormatDefaultText];
    
    if ([CommonUtils isValidString:defaultText])
    {
        _defaultButton.hidden = NO;
        [_defaultButton setTitle:defaultText forState:UIControlStateNormal];
        _titleLabelLeadingConstraint.constant = TEXTFIELD_TRAILING_CONSTANT_DEFAULT;
    }
    else
    {
        _defaultButton.hidden = YES;
        [_defaultButton setTitle:EMPTY_STRING forState:UIControlStateNormal];
        _titleLabelLeadingConstraint.constant = TEXTFIELD_TRAILING_CONSTANT_DEFAULT - _defaultButton.frame.size.width;
    }
    
    //Set textfield capitalization
    NSString *elementCapitalizationType = elementModel.printedTextFormat[kPdfFormatCapitalization];
    
    if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationAll])
    {
        _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    else if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationNone])
    {
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationWord])
    {
        _textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationSentences])
    {
        _textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationPassword])
    {
        _textField.secureTextEntry = YES;
    }
    else if ([elementCapitalizationType isEqualToString:PdfFormatCapitalizationEmail])
    {
        _textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
    //Set textfield Keyboard
    NSString *elementKeyboardType = elementModel.printedTextFormat[kPdfFormatKeyboard];
    
    if ([elementKeyboardType isEqualToString:PdfFormatKeyboardAlphabetic])
    {
        _textField.keyboardType = UIKeyboardTypeAlphabet;
    }
    else if ([elementKeyboardType isEqualToString:PdfFormatKeyboardAlphaNumeric])
    {
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([elementKeyboardType isEqualToString:PdfFormatKeyboardNumeric])
    {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    //TODO: Check this code may be place in Text field end editing method
    //Set TextField Decimal Values
    NSString *elementNumericType = elementModel.printedTextFormat[kPdfFormatDecimal];
    
    if([elementKeyboardType isEqualToString:PdfFormatKeyboardNumeric] &&
         [CommonUtils isValidString: elementNumericType])
    {
        NSInteger roundUpNumber = [elementNumericType integerValue];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setRoundingMode: NSNumberFormatterRoundUp];
        [numberFormatter setMaximumFractionDigits:roundUpNumber];
        [numberFormatter setMinimumFractionDigits:roundUpNumber];
        _textField.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [_textField.text floatValue]]];
    }
    
    //Set TextField Alignment
    NSString *elementAllignmentType = elementModel.printedTextFormat[kPdfFormatAlignment];
    
    _textField.textAlignment = NSTextAlignmentLeft;
    
    if([CommonUtils isValidString: elementAllignmentType])
    {
        if([elementAllignmentType isEqualToString:PdfFormatAlignLeft])
        {
            _textField.textAlignment = NSTextAlignmentLeft;
        }
        else if ([elementAllignmentType isEqualToString:PdfFormatAlignRight])
        {
            _textField.textAlignment = NSTextAlignmentRight;
        }
        else if ([elementAllignmentType isEqualToString:PdfFormatAlignCenter])
        {
            _textField.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    [_textLabel sizeToFit];
    [self setRemainingChars];
}

#pragma mark -

- (void)setRemainingChars
{
    NSInteger remainingCharsCount = self.elementModel.maxCharLimit - _textField.text.length;
    
    if (remainingCharsCount >= 0)
    {
        _charLimitLabel.text = @(remainingCharsCount).stringValue;
    }
    else
    {
        _charLimitLabel.text = @(0).stringValue;
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //** if the Element Model is of type Date then open Date Picker in Input View
    UIDatePicker *datePicker  = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didchangeInDate:) forControlEvents:UIControlEventValueChanged];
    self.elementModel.printedTextFormat[kPdfFormatKeyboard] ? (textField.inputView = datePicker) : nil;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *const UserEmail    = @"user_email";
    NSString *const UserPassword = @"user_password";
    
    self.elementModel.dataValue = textField.text;
    
    // Trimming White Space from Leading and Trailing of Text Field in case of LoginFields Element
    if( [self.elementModel.fieldName isEqualToString: UserEmail] ||
        [self.elementModel.fieldName isEqualToString: UserPassword] )
    {
        self.elementModel.dataValue = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger remainingChars = 0;
    
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

#pragma mark - Private Methods

// This method is used to add the date on the Respective Date Field in the Given Format
- (void)didchangeInDate:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([CommonUtils isValidObject:self.elementModel.printedTextFormat[kPDFDateFormat]])
    {
        dateFormatter.dateFormat = self.elementModel.printedTextFormat[kPDFDateFormat]; // Add Date Format, if Exist
    }
    
    NSString *dateString = [dateFormatter stringFromDate:picker.date];
    _textField.text      = dateString;
}
@end
