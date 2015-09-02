//
//  TickBoxElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TickBoxElementCell.h"

@implementation TickBoxElementCell
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

- (TickBoxElementCell *)initWithModel:(ElementModel *)formElement
{
    [self fillWithData:formElement.dataValue];
    _textLabel.text = formElement.label;
    return self;
}

- (IBAction)onClickTickBoxButton:(UIButton *)tickBoxButton {
    //Add arrowImageView with arrow sign
    if(!tickBoxButton.selected)
        tickBoxButton.selected = YES;
    else
        tickBoxButton.selected = NO;
}

- (void)autoFillBillingAddressFields
{
    
}

@end
