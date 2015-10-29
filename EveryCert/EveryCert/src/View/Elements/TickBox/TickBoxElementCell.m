//
//  TickBoxElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "TickBoxElementCell.h"
#import "CertViewController.h"

@implementation TickBoxElementCell
{
    __weak IBOutlet UILabel *_textLabel;
    __weak IBOutlet UIButton *_tickBoxButton;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    _tickBoxButton.selected = NO;
    _textLabel.text = elementModel.label;
}

- (IBAction)onClickTickBoxButton:(UIButton *)tickBoxButton
{
    NSArray *copyFieldArray = self.elementModel.printedTextFormat[kTickBox];
    
    NSArray *currentSectionElements = APP_DELEGATE.certificateVC.currentSectionElements;
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    
    for(NSDictionary *dictionary in copyFieldArray)
    {
        NSString *key = [[dictionary allKeys] firstObject];
        ElementModel *elementModel = [[APP_DELEGATE.certificateVC.formElements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.fieldName CONTAINS %@",dictionary[key]]] firstObject];
        
        
        [mutableDict setObject:elementModel.dataValue forKey:key];
    }
    
    for(ElementModel *elementModel in currentSectionElements)
    {
        if([CommonUtils isValidObject: mutableDict[elementModel.fieldName]])
        {
            elementModel.dataValue = mutableDict[elementModel.fieldName];
        }
    }
    
    [APP_DELEGATE.certificateVC.elementTableView reloadData];
    
    //Add arrowImageView with arrow sign
    if(!tickBoxButton.selected)
    {
        tickBoxButton.selected      = YES;
        self.elementModel.dataValue = @"YES";
    }
    
    else
    {
        tickBoxButton.selected      = NO;
        self.elementModel.dataValue = @"NO";
    }
}

@end
