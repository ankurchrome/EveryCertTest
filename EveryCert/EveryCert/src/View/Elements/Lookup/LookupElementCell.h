//
//  LookupElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface LookupElementCell : ElementTableViewCell

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (LookupElementCell *)initWithModel:(ElementModel *)formElement;

@end
