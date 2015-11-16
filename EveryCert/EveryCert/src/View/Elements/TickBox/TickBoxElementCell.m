//
//  TickBoxElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 12/08/15.
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
    
    if ([self.elementModel.dataValue isEqualToString:@"YES"])
    {
        _tickBoxButton.selected = YES;
    }
    else
    {
        _tickBoxButton.selected = NO;
    }
    
    _textLabel.text = elementModel.label;
}

- (IBAction)onClickTickBoxButton:(UIButton *)tickBoxButton
{
    //Add arrowImageView with arrow sign
    if (!tickBoxButton.selected)
    {
        [self fillWithData];
        tickBoxButton.selected      = YES;
        self.elementModel.dataValue = @"YES";
    }
    else
    {
        tickBoxButton.selected      = NO;
        self.elementModel.dataValue = @"NO";
        
        // Empty all Current Section's Element Data on UnMark of TickBox
        for(ElementModel *elementModel in APP_DELEGATE.certificateVC.currentSectionElements)
        {
             elementModel.dataValue = EMPTY_STRING;
        }
    }
    
    [APP_DELEGATE.certificateVC.elementTableView reloadData];   // Reload Element Table View
}

// Fill all those Current Section's Elements data that hving entry in PrintedTextFormat of Tick Box
- (void)fillWithData
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
}

@end
