//
//  ElementTableViewCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementModel.h"
#import "UIView+Extension.h"
#import "CertificateViewController.h"

@interface ElementTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *subElementViews;
@property (strong, nonatomic) ElementModel *elementModel;
@property (strong, nonatomic) CertificateViewController *certificateViewController;

//@property (strong, nonatomic) FormElementsViewController *formElementsVC;

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (id)initWithModel:(ElementModel *)formElement;

/**
 Fill the element controls with the given data
 @param  data Data could be any type of NSString, NSData etc. It is depend of element type
 @return void
 */

- (void)fillWithData:(id)data;

@end

extern NSString *const AccessoryRightArrowImageName;
extern NSString *const AccessoryDownArrowImageName;
extern NSString *const AccessoryCheckMarkImageName;