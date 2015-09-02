//
//  FormElementModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    ElementTypeSearch         = 0, // Not Used
    ElementTypeTextField      = 1,
    ElementTypeTextView       = 2,
    ElementTypePicker         = 3, // Not Used
    ElementTypeLookup         = 4, // Not Used
    ElementTypeSignature      = 5,
    ElementTypePickListOption = 6,
    ElementTypeSubElements    = 7,
    ElementTypeRadioButton    = 8,
    ElementTypeLine           = 9, // Not Used
    ElementTypeTickBox        = 10,
    ElementTypeTextLabel      = 11,
    ElementTypePhoto          = 12 // Not Used
}FormElementType;

@interface ElementModel : NSObject

@property (assign, nonatomic) NSInteger elementId;
@property (assign, nonatomic) NSInteger elementIdApp;
@property (assign, nonatomic) NSInteger elementSectionId;
@property (assign, nonatomic) NSInteger elementFormId;
@property (assign, nonatomic) NSInteger fieldType;
@property (strong, nonatomic) NSString  *fieldName;
@property (assign, nonatomic) NSInteger sequenceOrder;
@property (strong, nonatomic) NSString  *label;
@property (assign, nonatomic) NSInteger originX;
@property (assign, nonatomic) NSInteger originY;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) NSInteger minCharLimit;
@property (assign, nonatomic) NSInteger maxCharLimit;
@property (strong, nonatomic) NSDictionary *elementPrintedTextFormat;
@property (assign, nonatomic) NSInteger linkedElementId;
@property (strong, nonatomic) NSString  *modifiedTimestamp;
@property (assign, nonatomic) NSInteger archive;
@property (strong, nonatomic) NSString  *popUpMessage;
@property (assign, nonatomic) NSInteger lookUpIdNew;
@property (assign, nonatomic) NSInteger fieldNumberNew;
@property (assign, nonatomic) NSInteger lookUpIdExisting;
@property (assign, nonatomic) NSInteger fieldNumberExisting;
@property (strong, nonatomic) NSArray  *subElements;
@property (strong, nonatomic) NSString *dataValue;
@property (strong, nonatomic) NSData   *dataBinary;

/**
 This Method is used to initialize the Result Set
 @param  FMResultSet Object of FMResult Set
 @return void
 */
- (void)initWithResultSet:(FMResultSet *)resultSet;

@end

extern NSString *const kElementFontSize;
extern NSString *const kElementFontColor;
extern NSString *const kElementFontName;
extern NSString *const kElementPickListType;
extern NSString *const kElementRadioButtons;
extern NSString *const kElementRadioButtonTitle;
extern NSString *const kElementRadioButtonSelectedIndex;
extern NSString *const kDefaultText;

