//
//  RadioButtonView.h
//  GasEngineerSoftware
//
//  Created by Ankur Pachauri on 21/02/14.
//  Copyright (c) 2014 Software Works for You Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIO_BUTTON_HEIGHT 30
#define RADIO_BUTTON_TITLE_FONT_SIZE   16
#define RADIO_BUTTON_TITLE_FONT_COLOUR [UIColor darkGrayColor]

typedef enum : NSUInteger
{
    RadioButtonViewLayoutVertical,
    RadioButtonViewLayoutHorizontal,
} RadioButtonViewLayout;

@class RadioButtonView;

@protocol RadioButtonViewDelegate <NSObject>

- (void)radioButtonViewValueChanged:(RadioButtonView *)radioButtonView;

@end

@interface RadioButtonView : UIView
{
    @private
    
    NSMutableArray *_radioButtons;
}

@property(nonatomic, assign, readonly) BOOL isSelected;
@property(nonatomic, assign, readonly) NSInteger selectedButtonIndex;
@property(nonatomic, strong, readonly) UIButton  *selectedButton;
@property(nonatomic, strong, readonly) NSString  *selectedValue;
@property(nonatomic, strong) id<RadioButtonViewDelegate> delegate;

/**
 Initialize a radio group view containing radio buttons for all the given options. Arrange the radio buttons in row-column manner so that one row will contain given no of columns only.
 @param  NSArray A list of options to be show on each radio button
 @param  RadioButtonViewLayout A Layout that tells to arrance the Radio Button Options in Vertical or Horizontal Manner
 @return void 
 */
- (void)reloadWithOptions:(NSArray *)options layout:(RadioButtonViewLayout)layout;

/**
 Select the radio button at the given index
 @param  index An index value of a radio button in the radio group
 @return void
 */
- (void)selectButtonWithIndex:(NSInteger)index;

/**
 Select the radio button for the given title
 @param  title A title value of a radio button in the radio group
 @return void
 */
- (void)selectButtonWithTitle:(NSString *)title;

@end
