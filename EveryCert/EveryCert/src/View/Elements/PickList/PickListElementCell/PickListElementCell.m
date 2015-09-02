//
//  PickListElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "PickListElementCell.h"

@implementation PickListElementCell
{

}

NSString *const PickListMakeDidChangedNofication = @"PickListMakeDidChanged";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithModel:(ElementModel *)formElement
{
    self = [super init];
    [self fillWithData:formElement.dataValue];
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    NSString *optionsString = data;
    
    if (data && [data isKindOfClass:[NSString class]])
    {
        _selectedOptions = [optionsString componentsSeparatedByString:@", "];
    }
    
    FUNCTION_END;
}

/**
 Called when TouchUpInside event occured on PickerElement. It will show the Options list to pick.
 @param  button A tapped UIButton object.
 @return void
 */
- (void)pickerElementTapped:(UIButton *)button
{
    FUNCTION_START;
    UIViewController *pickListVC = nil;
    
    pickListVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [rootController presentViewController:pickListVC animated:YES completion:nil];
    
    FUNCTION_END;
}

#pragma mark - PickListViewControllerDelegate Methods

- (void)pickListViewController:(PickListViewController *)pickList didSelectOptions:(NSArray *)selectedOptions
{
    _selectedOptions = selectedOptions;
    
    self.elementModel.dataValue = [_selectedOptions componentsJoinedByString:@", "];
}

- (void)pickList:(PickListViewController *)pickList didSelectItem:(NSString *)item
{
    _selectedOptionLabel.text = item;
    self.elementModel.dataValue = item;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PickListMakeDidChangedNofication
                                                  object:nil];
}

@end
