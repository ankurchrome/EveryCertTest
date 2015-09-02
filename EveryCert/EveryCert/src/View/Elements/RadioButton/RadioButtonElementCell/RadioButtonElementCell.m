//
//  RadioButtonElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RadioButtonElementCell.h"

#define RADIO_BUTTONS_IN_A_ROW 3.0
#define MARGIN_LEFT    25.0f
#define MARGIN_RIGHT   10.0f
#define MARGIN_TOP     5.0f
#define MARGIN_BOTTOM  5.0f
#define MARGIN_BETWEEN 10.0f

NSString *const kRadioButton = @"RadioButtons";
NSString *const kRadioButtonTitle = @"RadioButtonTitle";

@implementation RadioButtonElementCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __strong IBOutlet RadioButtonView *_radioButtonView;
    __weak IBOutlet NSLayoutConstraint *_viewHeigthConstraint;
    
    NSArray *_radioButtons;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (RadioButtonElementCell *)initWithModel:(ElementModel *)element
{
    int radioButtonLayoutFormat = RadioButtonViewLayoutVertical;
    [self fillWithData:element.dataValue];
    _titleLabel.text = element.label;
    
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[RadioButtonView class]])
        {
            [view removeAllSubviews];
        }
    }
    
    NSArray *radioButtons       =  element.printedTextFormat[kRadioButton];
    NSArray *radioButtonOptions = [radioButtons valueForKeyPath:kRadioButtonTitle];
    
    if(radioButtonLayoutFormat == RadioButtonViewLayoutHorizontal)
    {
        _viewHeigthConstraint.constant = RadioButtonHeight;
        [_radioButtonView reloadWithOptions:radioButtonOptions layout:RadioButtonViewLayoutHorizontal];
    }
    else
    {
        [_radioButtonView setFrameHeight:radioButtonOptions.count * RadioButtonHeight];
        _viewHeigthConstraint.constant = radioButtonOptions.count * RadioButtonHeight;
        [_radioButtonView reloadWithOptions:radioButtonOptions layout:RadioButtonViewLayoutVertical];
    }
    _radioButtonView.delegate = self;
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    if (data && [data isKindOfClass:[NSString class]])
    {
        [_radioButtonView selectButtonWithTitle:data];
    }
    
    FUNCTION_END;
}

#pragma mark - RadioButtonViewDelegate Methods

- (void)radioButtonViewValueChanged:(RadioButtonView *)radioButtonView
{
    if (_radioButtons && radioButtonView.selectedButtonIndex < _radioButtons.count)
    {
        NSDictionary *radioButtonInfo = _radioButtons[radioButtonView.selectedButtonIndex];
        self.elementModel.dataValue = radioButtonInfo[@"RadioButtonValue"];
    }
    
    if([self.elementModel.fieldName isEqualToString:@"nature_of_visit"] && [self.elementModel.dataValue isEqualToString:@"Aborted Call"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AbortedCall" object:self];
    }
    
    if (LOGS_ON) NSLog(@"%@", self.elementModel.dataValue);
}

@end
