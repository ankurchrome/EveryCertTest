//
//  PickListElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"
#import "PickListViewController.h"

@interface PickListElementCell : ElementTableViewCell<PickListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedOptionLabel;
@property (nonatomic, strong) NSArray *selectedOptions;


@end
