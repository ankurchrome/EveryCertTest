//
//  TextViewElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"

@interface TextViewElementCell : ElementTableViewCell<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
