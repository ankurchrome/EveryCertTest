//
//  RadioButtonView.m
//  GasEngineerSoftware
//
//  Created by Ankur Pachauri on 21/02/14.
//  Copyright (c) 2014 Software Works for You Ltd. All rights reserved.
//

#import "RadioButtonView.h"
#import "UIView+Extension.h"

@interface RadioButtonView ()
{
    NSInteger _defaultSelectedButtonIndex;
}
@end

NSString *const UnCheckedImage = @"RadioButtonUnchecked";
NSString *const CheckedImage = @"RadioButtonChecked";

@implementation RadioButtonView

// Initialize a radio group view containing radio buttons for all the given options. Arrange the radio buttons in row-column manner so that one row will contain given no of columns only.
- (void)reloadWithOptions:(NSArray *)options layout:(RadioButtonViewLayout)layout
{
    if (!_radioButtons)
    {
        _radioButtons = [NSMutableArray new];
    }
    
    [_radioButtons removeAllObjects];
    [self removeAllSubviews];
    
    CGRect radioButtonFrame = CGRectZero;
    
    if (layout == RadioButtonViewLayoutHorizontal)
    {
        radioButtonFrame.size.width  = self.frame.size.width/options.count;
        radioButtonFrame.size.height = self.frame.size.height;
        radioButtonFrame.origin.y    = 0;
    }
    else if (layout == RadioButtonViewLayoutVertical)
    {
        radioButtonFrame.size.width  = self.frame.size.width;
        radioButtonFrame.size.height = RADIO_BUTTON_HEIGHT;
        radioButtonFrame.origin.x = 0;
    }
    
    for (int optionIndex = 0; optionIndex < options.count; optionIndex++)
    {
        if (layout == RadioButtonViewLayoutHorizontal)
        {
            radioButtonFrame.origin.x = optionIndex*radioButtonFrame.size.width;
        }
        else if (layout == RadioButtonViewLayoutVertical)
        {
            radioButtonFrame.origin.y = optionIndex * RADIO_BUTTON_HEIGHT;
        }
            UIButton *radioButton = [[UIButton alloc] initWithFrame:radioButtonFrame];
            
            [radioButton setImage:[UIImage imageNamed:UnCheckedImage]
                         forState:UIControlStateNormal];
            [radioButton setImage:[UIImage imageNamed:CheckedImage]
                         forState:UIControlStateSelected];
            [radioButton setTitleColor:[UIColor blackColor]
                              forState:UIControlStateNormal];
            [radioButton setTitle:options[optionIndex]
                         forState:UIControlStateNormal];
            [radioButton addTarget:self
                            action:@selector(touchUpOnRadioButton:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            radioButton.tag = optionIndex;
            radioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            radioButton.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleWidth;
            [self addSubview:radioButton];
            [_radioButtons addObject:radioButton];
}
}

//select the only button on which touchUpInside occur
- (void)touchUpOnRadioButton:(UIButton *)sender
{
    FUNCTION_START;
    
    _isSelected = true;
    
    for (UIButton *radioButton in _radioButtons)
    {
        radioButton.selected = NO;
        [radioButton setTitleColor:[UIColor blackColor]
                          forState:UIControlStateNormal];    // Change Selected Button's Tilte Color to Black
    }
    
    sender.selected = YES;
    _selectedButtonIndex = sender.tag;
    _selectedButton = sender;
    _selectedValue = [sender titleForState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(radioButtonViewValueChanged:)])
    {
        [_delegate radioButtonViewValueChanged:self];
    }
    
    FUNCTION_END;
}

//Select the radio button at the given index
- (void)selectButtonWithIndex:(NSInteger)index
{
    FUNCTION_START;
    
    for (UIButton *radioButton in _radioButtons)
    {
        if (radioButton.tag == index)
        {
            [self touchUpOnRadioButton:radioButton];
            
            break;
        }
    }
    
    FUNCTION_END;
}

//Select the radio button for the given title
- (void)selectButtonWithTitle:(NSString *)title
{
    FUNCTION_START;
    
    for (UIButton *radioButton in _radioButtons)
    {
        NSString *buttonTitle = [radioButton titleForState:UIControlStateNormal];
        if ([buttonTitle isEqualToString:title])
        {
            [self touchUpOnRadioButton:radioButton];
            break;
        }
    }
    
    FUNCTION_END;
}

//Clear all values of radio group control and unselect the previous selected button if any
- (void)makeNoRadioButtonSelected
{
    _isSelected = false;
    
    for (UIButton *radioButton in _radioButtons)
    {
        radioButton.selected = NO;
    }
    
    _selectedButtonIndex = -1;
    _selectedButton = nil;
    _selectedValue = EMPTY_STRING;
}

@end
