//
//  SubElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SubElementCell.h"

@implementation SubElementCell
{
    __weak IBOutlet UIImageView *_arrowImageView;
    __weak IBOutlet UILabel *_titleLabel;
    BOOL _isSubElementShowing;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (SubElementCell *)initWithModel:(ElementModel *)formElement
{
    [self fillWithData:formElement.dataValue];
    _titleLabel.text = formElement.label;
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    NSDictionary *subElementInfo = nil;
    NSData *subElementData = nil;
    
    if (data && [data isKindOfClass:[NSString class]])
    {
        subElementData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        if (subElementData)
        {
            subElementInfo = [NSJSONSerialization JSONObjectWithData:subElementData options:NSJSONReadingMutableContainers error:nil];
        }
        
        if (subElementInfo)
        {
            for (ElementTableViewCell *elementView in self.subElementViews)
            {
                NSString *subElementKey = @(elementView.elementModel.elementId).stringValue;
                NSString *value = nil;
                
                if (subElementKey)
                {
                    value = [subElementInfo valueForKey:subElementKey];
                    elementView.elementModel.dataValue = value;
                    [elementView fillWithData:value];
                }
            }
        }
    }
    
    FUNCTION_END;
}

//Called when sub element gets tapped.
- (void)showTable:(UITapGestureRecognizer *)recognizer
{
    FUNCTION_START;
    
    if (_isSubElementShowing)
    {
        _arrowImageView.image = [UIImage imageNamed:AccessoryRightArrowImageName];
       
//TODO: Change Comment
//        [self.formElementsVC hideSubElements:self.subElementViews ofElement:self];
        
        _isSubElementShowing = NO;
    }
    else
    {
        _arrowImageView.image = [UIImage imageNamed:AccessoryDownArrowImageName];
        
//TODO: Change Comment
//        [self.formElementsVC showSubElements:self.subElementViews ofElement:self];
        
        _isSubElementShowing = YES;
    }
    
    FUNCTION_END;
}

@end
