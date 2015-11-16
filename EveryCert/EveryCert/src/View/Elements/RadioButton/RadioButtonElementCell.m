//
//  RadioButtonElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RadioButtonElementCell.h"
#import "RadioButtonView.h"

#define RADIO_BUTTONS_IN_A_ROW 3.0
#define MARGIN_LEFT    25.0f
#define MARGIN_RIGHT   10.0f
#define MARGIN_TOP     5.0f
#define MARGIN_BOTTOM  5.0f
#define MARGIN_BETWEEN 10.0f

@interface RadioButtonElementCell ()<RadioButtonViewDelegate>

@end

@implementation RadioButtonElementCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __strong IBOutlet RadioButtonView *_radioButtonView;
    __weak IBOutlet NSLayoutConstraint *_viewHeigthConstraint;
    
    NSArray *_radioButtons;
    NSArray *_radioButtonOptions;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _titleLabel.text = elementModel.label;
    [_radioButtonView removeAllSubviews];
    
    _radioButtons       =  elementModel.printedTextFormat[kPdfFormatRadioButtons];
    _radioButtonOptions = [_radioButtons valueForKeyPath:kPdfFormatRadioButtonTitle];
    
    if(_radioButtons.count <= 3)
    {
        _viewHeigthConstraint.constant = RADIO_BUTTON_HEIGHT;
        [_radioButtonView reloadWithOptions:_radioButtonOptions
                                     layout:RadioButtonViewLayoutHorizontal];
    }
    else
    {
        [_radioButtonView setFrameHeight:_radioButtonOptions.count * RADIO_BUTTON_HEIGHT];
        _viewHeigthConstraint.constant = _radioButtonOptions.count * RADIO_BUTTON_HEIGHT;
        [_radioButtonView reloadWithOptions:_radioButtonOptions
                                     layout:RadioButtonViewLayoutVertical];
    }
    
    _radioButtonView.delegate = self;
    
    // Filter only selected RadioButton Dictionary and find its Title to compare it with Button Title
    NSDictionary *selectedRadioButton = [[_radioButtons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(RadioButtonValue == %@)", elementModel.dataValue]] firstObject];
    
    [_radioButtonView selectButtonWithTitle:selectedRadioButton[@"RadioButtonTitle"]];
}

#pragma mark - RadioButtonViewDelegate Methods

- (void)radioButtonViewValueChanged:(RadioButtonView *)radioButtonView
{
    if (_radioButtons && radioButtonView.selectedButtonIndex < _radioButtons.count)
    {
        NSDictionary *radioButtonInfo = _radioButtons[radioButtonView.selectedButtonIndex];
        self.elementModel.dataValue = radioButtonInfo[kPdfFormatRadioButtonValue];
    }
}

@end
