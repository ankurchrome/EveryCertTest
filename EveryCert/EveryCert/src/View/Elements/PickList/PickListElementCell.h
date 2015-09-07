//
//  PickListElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface PickListElementCell : ElementTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedOptionLabel;

@end