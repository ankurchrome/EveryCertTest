//
//  ElementTableViewCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@implementation ElementTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Initialize Element Cell with info containing in ElementModel object
- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    _elementModel = elementModel;
}

@end
