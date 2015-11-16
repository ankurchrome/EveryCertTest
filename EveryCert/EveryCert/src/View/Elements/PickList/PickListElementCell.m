//
//  PickListElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "PickListElementCell.h"
#import "PickListViewController.h"

@interface PickListElementCell ()<PickListViewControllerDelegate>

@end

@implementation PickListElementCell
{
    NSArray *_selectedOptions;
    NSArray *_allOptions;
}

NSString *const PickListMakeDidChangedNofication = @"PickListMakeDidChanged";

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _titleLabel.text = elementModel.label;
    _selectedOptions = [elementModel.dataValue componentsSeparatedByString:@"; "];
}

// Called when TouchUpInside event occured on PickerElement. It will show the Options list to pick.
- (void)pickerElementTapped:(UIButton *)button
{
    PickListViewController *pickListVC = [[PickListViewController alloc] initWithSelectedOptions:_selectedOptions allOptions:_allOptions];
    
    pickListVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [rootController presentViewController:pickListVC animated:YES completion:nil];
}

#pragma mark - PickListViewControllerDelegate Methods

- (void)pickListViewController:(PickListViewController *)pickList didSelectOptions:(NSArray *)selectedOptions
{
    _selectedOptions = selectedOptions;
    
    self.elementModel.dataValue = [_selectedOptions componentsJoinedByString:@"; "];
}

@end
