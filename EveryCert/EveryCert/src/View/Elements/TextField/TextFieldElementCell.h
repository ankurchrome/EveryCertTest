//
//  TextFieldElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface TextFieldElementCell : ElementTableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end