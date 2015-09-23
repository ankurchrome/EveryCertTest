//
//  LineElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 09/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementTableViewCell.h"

@interface LineElementCell : ElementTableViewCell

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (LineElementCell *)initWithModel:(ElementModel *)formElement;

@end
