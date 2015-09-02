//
//  TextViewElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface TextViewElementCell : ElementTableViewCell<UITextViewDelegate>

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (TextViewElementCell *)initWithModel:(ElementModel *)formElement;

@end
