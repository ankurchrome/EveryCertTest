//
//  ElementTableViewCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"
#import "ElementModel.h"
#import "TextFieldElementCell.h"
#import "TextViewElementCell.h"
#import "TextLabelElementCell.h"
#import "SubElementCell.h"
#import "TickBoxElementCell.h"
#import "RadioButtonElementCell.h"
#import "SignatureElementCell.h"
#import "LookupElementCell.h"
#import "PickListElementCell.h"

@implementation ElementTableViewCell

NSString *const AccessoryRightArrowImageName = @"ArrowRight";
NSString *const AccessoryDownArrowImageName = @"ArrowDown";
NSString *const AccessoryCheckMarkImageName = @"CheckMark";
NSString *const DefaultElementRectString = @"{{0,0},{500,44}}";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Initialize Cell Element with their information
- (ElementTableViewCell *)initWithModel:(ElementModel *)formElement{
    self = [super init];
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data{

}

// Make UIView object using through info contains in FormElementModel object.
- (id)getViewForFormElement:(ElementModel *)formElement delegate:(id)delegate
{
    FormElementType type = formElement.fieldType;
    //CGRect viewRect = CGRectFromString(DefaultElementRectString);
    
    ElementTableViewCell *elementView = nil;
    
    switch (type)
    {
        case ElementTypeTextField:
        {
            elementView = [[TextFieldElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeTextView:
        {
            elementView = [[TextViewElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeTextLabel:
        {
            elementView = [[TextLabelElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeSignature:
        {
            elementView  = [[SignatureElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypePickListOption:
        {
            elementView  = [[PickListElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeSubElements:
        {
            elementView  = [[SubElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeRadioButton:
        {
            elementView = [[RadioButtonElementCell alloc] initWithModel:formElement];
        }
            break;
            
        case ElementTypeTickBox:
        {
            elementView = [[TickBoxElementCell alloc] initWithModel:formElement];
        }
            break;
            
        default:
            break;
    }
    
    return elementView;
}

@end
