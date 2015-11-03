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

@interface ElementTableViewCell : UITableViewCell

@property (strong, nonatomic) ElementModel *elementModel;
@property (strong, nonatomic) IBOutlet UIView *seperatorView;

/**
 Initialize Element Cell with info containing in ElementModel object
 @param  ElementModel object which contains info like section, title etc.
 */
- (void)initializeWithElementModel:(ElementModel *)elementModel;

@end