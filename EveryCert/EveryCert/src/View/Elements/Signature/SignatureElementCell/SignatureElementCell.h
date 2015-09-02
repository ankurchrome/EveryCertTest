//
//  SignatureElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"
#import "SignatureViewController.h"

@interface SignatureElementCell : ElementTableViewCell<SignatureViewControllerDelegate>

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (SignatureElementCell *)initWithModel:(ElementModel *)formElement;

@end
