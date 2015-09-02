//
//  LookupElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookupElementCell.h"

@implementation LookupElementCell
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

- (LookupElementCell *)initWithModel:(ElementModel *)formElement
{
    [self fillWithData:formElement.dataValue];
    _textLabel.text = formElement.label;
    return self;
}

@end
