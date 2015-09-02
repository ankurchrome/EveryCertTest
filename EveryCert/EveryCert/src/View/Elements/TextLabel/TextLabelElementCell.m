//
//  TextLabelElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TextLabelElementCell.h"

@implementation TextLabelElementCell
{    
    __weak IBOutlet UILabel *_textLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TextLabelElementCell *)initWithModel:(ElementModel *)formElement
{
    [self fillWithData:formElement.dataValue];
    _textLabel.text = formElement.label;
    return self;
}

// This Method is u=sed to initialize the TextLabelElement Cell with the FormSectionModel
- (TextLabelElementCell *)initWithSectionModel:(FormSectionModel *)sectionElement
{
    _textLabel.text = sectionElement.header;
    return self;
}

// This Method is u=sed to initialize the TextLabelElement Cell with the Section Model
- (TextLabelElementCell *)initWithCertificateModel:(CertificateModel *)certificateModel
{
    NSString *existingCertString = [NSString stringWithFormat:@"%@", certificateModel.name];
    _textLabel.text = existingCertString;
    return self;
}

@end
