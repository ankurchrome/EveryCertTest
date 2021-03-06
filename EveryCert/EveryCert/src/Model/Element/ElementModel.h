//
//  FormElementModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@class DataModel, DataBinaryModel, CompanyUserModel;

typedef enum : NSUInteger
{
    ElementTypeSearch         = 0,
    ElementTypeTextField      = 1,
    ElementTypeTextView       = 2,
    ElementTypePicker         = 3, // Not Used
    ElementTypeLookup         = 4, // Not Used
    ElementTypeSignature      = 5,
    ElementTypePickListOption = 6,
    ElementTypeSubElement     = 7,
    ElementTypeRadioButton    = 8,
    ElementTypeLine           = 9,
    ElementTypeTickBox        = 10, // Not Used
    ElementTypeTextLabel      = 11,
    ElementTypePhoto          = 12 // Not Used
} FormElementType;

@interface ElementModel : BaseModel

@property (assign, nonatomic) NSInteger elementId;
@property (assign, nonatomic) NSInteger sectionId;
@property (assign, nonatomic) NSInteger formId;
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
@property (strong, nonatomic) NSDictionary *printedTextFormat;
@property (assign, nonatomic) NSInteger linkedElementId;
@property (strong, nonatomic) NSString  *popUpMessage;
@property (assign, nonatomic) NSInteger lookUpListIdNew;
@property (assign, nonatomic) NSInteger fieldNumberNew;
@property (assign, nonatomic) NSInteger lookUpListIdExisting;
@property (assign, nonatomic) NSInteger fieldNumberExisting;

@property (strong, nonatomic) NSArray  *subElements;

//TODO: remove the unneccessary properties
@property (assign, nonatomic) NSInteger  dataIdApp;
@property (strong, nonatomic) NSString  *dataValue;
//@property (strong, nonatomic) DataModel *dataModel;

@property (assign, nonatomic) NSInteger        dataBinaryIdApp;
@property (strong, nonatomic) NSData          *dataBinaryValue;
//@property (strong, nonatomic) DataBinaryModel *dataBinaryModel;

@property (assign, nonatomic) NSInteger        companyUserIdApp;
@property (strong, nonatomic) NSString         *companyUserDataValue;
//@property (strong, nonatomic) CompanyUserModel *companyUserModel;

//@property (assign, nonatomic) NSInteger lookupIdApp;
@property (assign, nonatomic) NSInteger recordIdApp;
@property (assign, nonatomic) NSInteger linkedRecordIdApp;

@end
