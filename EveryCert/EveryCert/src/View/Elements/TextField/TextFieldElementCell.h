//
//  TextFieldElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface TextFieldElementCell : ElementTableViewCell<UITextFieldDelegate>

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (TextFieldElementCell *)initWithModel:(ElementModel *)formElement;

/**
 Initialize the Table View with the Data from Dictionary
 @param  NSString Contains the Label text String
 @return void Returns nothing
 */
- (void)initWithData:(NSString *)string;

@end
