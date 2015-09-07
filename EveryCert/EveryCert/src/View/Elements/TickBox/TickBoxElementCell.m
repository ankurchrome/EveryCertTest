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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _textLabel.text = elementModel.label;
}

- (IBAction)onClickTickBoxButton:(UIButton *)tickBoxButton
{
    tickBoxButton.selected = !tickBoxButton.selected;
}

@end
