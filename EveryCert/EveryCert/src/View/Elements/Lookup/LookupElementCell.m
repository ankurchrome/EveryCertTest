//
//  LookupElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookupElementCell.h"

@implementation LookupElementCell
{
    IBOutlet UILabel     *_titleLabel;
    IBOutlet UITextField *_textField;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _titleLabel.text = elementModel.label;
}

@end
