//
//  SubElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SubElementCell.h"

@implementation SubElementCell
{
    __weak IBOutlet UIImageView *_arrowImageView;
    __weak IBOutlet UILabel *_titleLabel;
    BOOL _isSubElementShowing;
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
