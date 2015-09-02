//
//  ConstantUtils.h
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

//Macros as some Shortcut
#define APP_DELEGATE   ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ROOT_NAVIGATOR ((RootNavigator *)self.navigationController)
#define IS_IOS_7 [[[UIDevice currentDevice].systemVersion substringToIndex:1] floatValue] >= 7.0
#define IS_LESS_THAN_IOS_7 [[[UIDevice currentDevice].systemVersion substringToIndex:1] floatValue] < 7.0
#define iPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define iPAD   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define FUNCTION_START if(LOGS_ON) NSLog(@"%s method start here",__FUNCTION__)
#define FUNCTION_END   if(LOGS_ON) NSLog(@"%s method end here",__FUNCTION__)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_IOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define LOGS_ON YES

//local Database Details
#define DATABASE_NAME   @"Everycert.sqlite"
#define DATABASE_TYPE   @"sqlite"
#define DATABASE_SCHEMA_SQL @"Everycert"

//Other Constants
#define EMPTY_STRING   @""
#define NULL_STRING1   @"(null)"
#define ZERO_STRING    @"0"

#define FORMS_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"Forms"]

#define FILE_TYPE_SQL @"sql"
#define PDF_EXTENSION @"pdf"

#define APP_BG_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
#define CERTIFICATE_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define EMAIL_REGEX    @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"

@interface Constant : NSObject

@end

//Common
extern NSString *const KeyboardWillResignNotification;
extern NSString *const ElementPdfDrawingFormat;
extern NSString *const ElementPdfDrawingContent;

//Table Names
extern NSString *const SettingTable;
extern NSString *const FormTable;
extern NSString *const FormSectionTable;
extern NSString *const ElementTable;
extern NSString *const SubElementTable;
extern NSString *const PickListOptionTable;
extern NSString *const DataTable;
extern NSString *const DataBinaryTable;
extern NSString *const CertificateTable;
extern NSString *const BurnerTypeTable;

//Common Columns
extern NSString *const ModifiedTimestampApp;
extern NSString *const ModifiedTimeStamp;
extern NSString *const Archive;
extern NSString *const UUid;
extern NSString *const IsDirty;
extern NSString *const CompanyId;

//Setting Table Columns
extern NSString *const SettingIdApp;
extern NSString *const SettingEngineerName;
extern NSString *const SettingEngineerSign;
extern NSString *const SettingEngineerEmail;
extern NSString *const SettingEngineerPassword;


//Form Table Columns
extern NSString *const FormIdApp;
extern NSString *const FormId;
extern NSString *const FormCategoryId;
extern NSString *const FormName;
extern NSString *const FormTitle;
extern NSString *const FormBackgroundLayout;
extern NSString *const FormStatus;
extern NSString *const FormCompanyFormat;
extern NSString *const FormSequenceOrder;

//FormSection Table Columns
extern NSString *const FormSectionId;
extern NSString *const FormSectionName;
extern NSString *const FormSectionSequenceOrder;
extern NSString *const FormSectionHeader;
extern NSString *const FormSectionFooter;
extern NSString *const FormSectionTitle;

//Element Table Columns
extern NSString *const ElementId;
extern NSString *const ElementSectionId;
extern NSString *const ElementFormId;
extern NSString *const ElementFieldType;
extern NSString *const ElementFieldName;
extern NSString *const ElementSequenceOrder;
extern NSString *const ElementLabel;
extern NSString *const ElementOriginX;
extern NSString *const ElementOriginY;
extern NSString *const ElementHeight;
extern NSString *const ElementWidth;
extern NSString *const ElementPageNumber;
extern NSString *const ElementMinChar;
extern NSString *const ElementMaxChar;
extern NSString *const ElementPrintedTextFormat;
extern NSString *const ElementLinkedElementId;
extern NSString *const ElementPopUpMessage;
extern NSString *const ElementLookUpListIdNew;
extern NSString *const ElementFieldNumberNew;
extern NSString *const ElementLookUpListIdExisting;
extern NSString *const ElementFieldNumberExisting;

//SubElement Table Columns
extern NSString *const SubElementId;

//Certificate Table Columns
extern NSString *const CertificateIdApp;
extern NSString *const CertificateId;
extern NSString *const CertificateFormId;
extern NSString *const CertificateName;
extern NSString *const CertificateIssuedApp;
extern NSString *const CertificateDate;
extern NSString *const CertificatePdf;

//LookUp Table Columns
extern NSString *const LookUpIdApp;
extern NSString *const LookUpId;
extern NSString *const LookUpListId;
extern NSString *const LookUpRecordIdApp;
extern NSString *const LookUpLinkedRecordIdApp;
extern NSString *const LookUpFieldNumber;
extern NSString *const Options;
extern NSString *const LookUpDataValue;
extern NSString *const LookUpSequenceOrder;

//PickListOptionTable Table Columns
extern NSString *const PickListOptionIdApp;
extern NSString *const PickListOptionType;
extern NSString *const PickListOptionName;
extern NSString *const PickListOptionValue;
extern NSString *const PickListOptionSequenceOrder;

//Data Table Columns
extern NSString *const DataIdApp;
extern NSString *const DataValue;
extern NSString *const DataId;
extern NSString *const RecordIdApp;

//DataBinary Table Columns
extern NSString *const DataBinaryIdApp;
extern NSString *const DataBinaryId;
extern NSString *const DataBinaryValue;

//Elements Reuse Identifier
extern NSString *const TextViewReuseIdentifier;
extern NSString *const TickBoxReuseIdentifier;
extern NSString *const TextLabelReuseIdentifier;
extern NSString *const TextFieldReuseIdentifier;
extern NSString *const SubElementsReuseIdentifier;
extern NSString *const SignatureViewReuseIdentifier;
extern NSString *const RadioButtonsReuseIdentifier;
extern NSString *const LookUpReuseIdentifier;
extern NSString *const PickListReuseIdentifier;

