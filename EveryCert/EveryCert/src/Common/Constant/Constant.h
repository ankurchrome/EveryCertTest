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

#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define iPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define iPAD   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define LOGS_ON YES
#define FUNCTION_START if(LOGS_ON) NSLog(@"%s method start here",__FUNCTION__)
#define FUNCTION_END   if(LOGS_ON) NSLog(@"%s method end here",__FUNCTION__)

//local Database Details
#define DATABASE_NAME       @"Everycert.sqlite"
#define DATABASE_TYPE       @"sqlite"
#define DATABASE_SCHEMA_SQL @"Everycert"

//Other Constants
#define EMPTY_STRING   @""

#define FORMS_BACKGROUND_LAYOUT_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"FormsBackgroundLayout"]

#define CERTIFICATES_PDF_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"CertificatesPdf"]

#define FILE_TYPE_SQL @"sql"
#define FILE_TYPE_PDF @"pdf"

#define APP_BLUE_COLOR [UIColor colorWithRed:21/255.0 green:126/255.0 blue:181/255.0 alpha:1.0]
#define APP_BG_COLOR   [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]
#define CERTIFICATE_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"

//Alert Messages Constants
#define ALERT_TITLE_WARNING       @"Warning!"
#define ALERT_TITLE_ERROR         @"Error"
#define ALERT_ACTION_TITLE_YES    @"Yes"
#define ALERT_ACTION_TITLE_NO     @"No"
#define ALERT_ACTION_TITLE_OK     @"Ok"
#define ALERT_ACTION_TITLE_CANCEL @"Cancel"
#define ALERT_MESSAGE_DELETE      @"Are you sure you wish to delete this?"
#define ALERT_MESSAGE_EMAIL_NOT_CONFIGURED @"No configured email account found, please check your setting."

@interface Constant : NSObject

@end

#pragma mark - Server Constants
#pragma mark -

#pragma mark API Constants

extern NSString *const BaseUrl;
extern NSString *const UrlApiV1;
extern NSString *const UrlTimestamp;

extern NSString *const MethodDownload;
extern NSString *const MethodDownloadSignature;
extern NSString *const ConnectionTimeoutMessage;
extern NSString *const ConnectionNotFoundMessage;
extern NSString *const SyncTimeMessage;

#pragma mark Key & Data Constants

extern NSString *const kPdfFormatElementFontName;
extern NSString *const kPdfFormatElementFontSize;
extern NSString *const kPdfFormatElementFontColor;

extern NSString *const kPdfFormatDefaultText;

extern NSString *const kPdfFormatRadioButtons;
extern NSString *const kPdfFormatRadioButtonTitle;
extern NSString *const kPdfFormatRadioButtonValue;
extern NSString *const kPdfFormatRadioButtonSelectedIndex;

extern NSString *const kPdfFormatAlignment;
extern NSString *const PdfFormatAlignLeft;
extern NSString *const PdfFormatAlignRight;
extern NSString *const PdfFormatAlignCenter;

extern NSString *const kPdfFormatCapitalization;
extern NSString *const PdfFormatCapitalizationAll;
extern NSString *const PdfFormatCapitalizationNone;
extern NSString *const PdfFormatCapitalizationWord;
extern NSString *const PdfFormatCapitalizationSentences;
extern NSString *const PdfFormatCapitalizationPassword;
extern NSString *const PdfFormatCapitalizationEmail;

extern NSString *const kPdfFormatKeyboard;
extern NSString *const PdfFormatKeyboardAlphabetic;
extern NSString *const PdfFormatKeyboardAlphaNumeric;
extern NSString *const PdfFormatKeyboardNumeric;

extern NSString *const kPdfFormatNumberOfLines;

#pragma mark - Table Constants
#pragma mark -
#pragma mark Common Columns
extern NSString *const ModifiedTimestampApp;
extern NSString *const ModifiedTimeStamp;
extern NSString *const Archive;
extern NSString *const Uuid;
extern NSString *const IsDirty;
extern NSString *const CompanyId;
extern NSString *const UserId;

#pragma mark CompanyUser Table
extern NSString *const CompanyUserTable;
extern NSString *const CompanyUserIdApp;
extern NSString *const CompanyUserId;
extern NSString *const CompanyUserFieldName;
extern NSString *const CompanyUserData;

extern NSString *const CompanyUserFieldNameEmail;
extern NSString *const CompanyUserFieldNamePassword;
extern NSString *const CompanyUserFieldNameFullName;
extern NSString *const CompanyUserFieldNamePermissionGroup;

#pragma mark Form Table
extern NSString *const FormTable;
extern NSString *const FormId;
extern NSString *const FormCategoryId;
extern NSString *const FormName;
extern NSString *const FormTitle;
extern NSString *const FormBackgroundLayout;
extern NSString *const FormStatus;
extern NSString *const FormCompanyFormat;
extern NSString *const FormSequenceOrder;
extern NSString *const FormPermissionGroup;

#pragma mark FormSection Table
extern NSString *const FormSectionTable;
extern NSString *const FormSectionId;
extern NSString *const FormSectionLabel;
extern NSString *const FormSectionSequenceOrder;
extern NSString *const FormSectionHeader;
extern NSString *const FormSectionFooter;
extern NSString *const FormSectionTitle;

#pragma mark Element Table
extern NSString *const ElementTable;
extern NSString *const ElementId;
extern NSString *const ElementFieldType;
extern NSString *const ElementFieldName;
extern NSString *const ElementSequenceOrder;
extern NSString *const ElementLabel;
extern NSString *const ElementOriginX;
extern NSString *const ElementOriginY;
extern NSString *const ElementHeight;
extern NSString *const ElementWidth;
extern NSString *const ElementPageNumber;
extern NSString *const ElementMinCharLimit;
extern NSString *const ElementMaxCharLimit;
extern NSString *const ElementPrintedTextFormat;
extern NSString *const ElementLinkedElementId;
extern NSString *const ElementPopUpMessage;
extern NSString *const ElementLookUpListIdNew;
extern NSString *const ElementFieldNumberNew;
extern NSString *const ElementLookUpListIdExisting;
extern NSString *const ElementFieldNumberExisting;

#pragma mark SubElement Table
extern NSString *const SubElementTable;
extern NSString *const SubElementId;

#pragma mark Certificate Table
extern NSString *const CertificateTable;
extern NSString *const CertificateIdApp;
extern NSString *const CertificateId;
extern NSString *const CertificateName;
extern NSString *const CertificateIssuedApp;
extern NSString *const CertificateDate;
extern NSString *const CertificatePdf;

#pragma mark Data Table
extern NSString *const DataTable;
extern NSString *const DataIdApp;
extern NSString *const DataId;
extern NSString *const DataValue;

#pragma mark DataBinary Table
extern NSString *const DataBinaryTable;
extern NSString *const DataBinaryIdApp;
extern NSString *const DataBinaryId;
extern NSString *const DataBinaryValue;

#pragma mark LookUp Table
extern NSString *const LookUpTable;
extern NSString *const LookUpIdApp;
extern NSString *const LookUpId;
extern NSString *const LookUpListId;
extern NSString *const LookUpLinkedRecordIdApp;
extern NSString *const LookUpFieldNumber;
extern NSString *const LookUpOption;
extern NSString *const LookUpDataValue;
extern NSString *const LookUpSequenceOrder;
extern NSString *const LookUpRecordTitleColumnAlias;//Being used as alias of group_concat(data) in LookupHandler

#pragma mark Record Table
extern NSString *const RecordTable;
extern NSString *const RecordIdApp;
extern NSString *const RecordId;

#pragma mark - App Constants
#pragma mark -

extern NSString *const HomeBarButtonTitle;

extern NSString *const ElementPdfDrawingFormat;
extern NSString *const ElementPdfDrawingContent;

extern NSString *const LoggedUserFullName;
extern NSString *const LoggedUserEmail;
extern NSString *const LoggedUserPassword;
extern NSString *const LoggedUserPermissionGroup;

#pragma mark ElementCell Reuse Identifier
extern NSString *const ElementCellReuseIdentifierSearch;
extern NSString *const ElementCellReuseIdentifierTextField;
extern NSString *const ElementCellReuseIdentifierTextView;
extern NSString *const ElementCellReuseIdentifierPicker;
extern NSString *const ElementCellReuseIdentifierLookUp;
extern NSString *const ElementCellReuseIdentifierSignature;
extern NSString *const ElementCellReuseIdentifierPickList;
extern NSString *const ElementCellReuseIdentifierSubElement;
extern NSString *const ElementCellReuseIdentifierRadioButton;
extern NSString *const ElementCellReuseIdentifierLine;
extern NSString *const ElementCellReuseIdentifierTickBox;
extern NSString *const ElementCellReuseIdentifierTextLabel;
extern NSString *const ElementCellReuseIdentifierPhoto;

#pragma mark ElementCell Reuse Identifier
extern NSString *const ElementCellNibNameSearch;
extern NSString *const ElementCellNibNameTextField;
extern NSString *const ElementCellNibNameTextView;
extern NSString *const ElementCellNibNamePicker;
extern NSString *const ElementCellNibNameLookUp;
extern NSString *const ElementCellNibNameSignature;
extern NSString *const ElementCellNibNamePickList;
extern NSString *const ElementCellNibNameSubElement;
extern NSString *const ElementCellNibNameRadioButton;
extern NSString *const ElementCellNibNameLine;
extern NSString *const ElementCellNibNameTickBox;
extern NSString *const ElementCellNibNameTextLabel;
extern NSString *const ElementCellNibNamePhoto;