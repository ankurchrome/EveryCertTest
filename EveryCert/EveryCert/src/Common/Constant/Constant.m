//
//  ConstantUtils.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "Constant.h"

@implementation Constant

#pragma mark - Server Constants
#pragma mark -

#pragma mark API Constants

#ifdef  PRODUCTION_URL
NSString *const ServerUrl = @"https://portal.everycert.co.uk/";
#else
#ifdef PRE_PRODUCTION_URL
NSString *const ServerUrl = @"https://portal.everycert.co.uk/";
#else
NSString *const ServerUrl = @"https://portal.everycert.co.uk/";
#endif
#endif

NSString *const ApiPath = @"api/v1/";
NSString *const ApiUrlParamTimestamp = @"timestamp";
NSString *const ApiLogin = @"login";
NSString *const ApiDownload = @"download";
NSString *const ApiDownloadSignature = @"downloadSig";

NSString *const ApiResponseKeyMetadata = @"metadata";
NSString *const ApiResponseKeyMetadataError = @"error";
NSString *const ApiResponseKeyMetadataTimestamp = @"timestamp";
NSString *const ApiResponseKeyNoOfRecords = @"no_records";
NSString *const ApiResponseKeyPayload  = @"payload";
NSString *const ApiResponseKeyPayloadPopupMessage = @"popupmessage";

NSString *const AlertMessageTryAgainLater      = @"Please try again later.";
NSString *const AlertMessageConnectionTimeout  = @"Connection time out, Please try again!";
NSString *const AlertMessageConnectionNotFound = @"Please check your internet connection and try again.";
NSString *const AlertMessageInitialSync        = @"Intial Sync will take up to 60 seconds please wait.";

#pragma mark Key & Data Constants

NSString *const kPdfFormatElementFontName  = @"ElementFontName";
NSString *const kPdfFormatElementFontSize  = @"ElementFontSize";
NSString *const kPdfFormatElementFontColor = @"ElementFontColor";

NSString *const kPdfFormatDefaultText = @"DefaultText";

NSString *const kPdfFormatRadioButtons     = @"RadioButtons";
NSString *const kPdfFormatRadioButtonTitle = @"RadioButtonTitle";
NSString *const kPdfFormatRadioButtonValue = @"RadioButtonValue";
NSString *const kPdfRadioButtonColor       = @"RadioButtonColor";
NSString *const kPdfFormatRadioButtonSelectedIndex = @"RadioButtonSelectedIndex";

NSString *const kPdfFormatAlignment = @"Alignment";
NSString *const PdfFormatAlignLeft = @"align_left";
NSString *const PdfFormatAlignRight = @"align_right";
NSString *const PdfFormatAlignCenter = @"align_centre";

NSString *const kPdfFormatCapitalization = @"ElementCaps";
NSString *const PdfFormatCapitalizationAll = @"uppercase";
NSString *const PdfFormatCapitalizationNone = @"lowercase";
NSString *const PdfFormatCapitalizationWord = @"capitalise_every_word";
NSString *const PdfFormatCapitalizationSentences = @"capitalise";
NSString *const PdfFormatCapitalizationPassword = @"password";
NSString *const PdfFormatCapitalizationEmail = @"email";

NSString *const kPdfFormatKeyboard = @"Keyboard";
NSString *const kPDFDateFormat     = @"date_format";
NSString *const PdfFormatKeyboardAlphabetic = @"alpha";
NSString *const PdfFormatKeyboardAlphaNumeric = @"alphanumeric";
NSString *const PdfFormatKeyboardNumeric = @"numeric";

NSString *const kPdfFormatNumberOfLines = @"number_lines";

#pragma mark - Table Constants
#pragma mark -
#pragma mark Common Columns
NSString *const ModifiedTimestampApp = @"modified_timestamp_app";
NSString *const ModifiedTimeStamp    = @"modified_timeStamp";
NSString *const Archive   = @"archive";
NSString *const Uuid      = @"uuid";
NSString *const IsDirty   = @"is_dirty";
NSString *const CompanyId = @"company_id";
NSString *const UserId    = @"user_id";

#pragma mark CompanyUser Table
NSString *const CompanyUserTable     = @"company_user";
NSString *const CompanyUserIdApp     = @"company_user_id_app";
NSString *const CompanyUserId        = @"company_user_id";
NSString *const CompanyUserFieldName = @"field_name";
NSString *const CompanyUserData      = @"data";
NSString *const UserFormStatusValue  = @"user_form_status";
NSString *const kStatus              = @"status";
NSString *const kFormId              = @"form_id";

NSString *const CompanyUserFieldNameEmail           = @"user_email";
NSString *const CompanyUserFieldNamePassword        = @"user_password";
NSString *const CompanyUserFieldNameFullName        = @"user_full_name";
NSString *const CompanyUserFieldNamePermissionGroup = @"permission_group";

#pragma mark Form Table
NSString *const FormTable            = @"form";
NSString *const FormId               = @"form_id";
NSString *const FormCategoryId       = @"category_id";
NSString *const FormName             = @"form_name";
NSString *const FormTitle            = @"form_title";
NSString *const FormBackgroundLayout = @"background_layout";
NSString *const FormStatus           = @"form_status";
NSString *const FormCompanyFormat    = @"company_format";
NSString *const FormSequenceOrder    = @"sequence_order";
NSString *const FormPermissionGroup  = @"permission_group";

#pragma mark FormSection Table
NSString *const FormSectionTable  = @"section";
NSString *const FormSectionId     = @"section_id";
NSString *const FormSectionLabel  = @"section_label";
NSString *const FormSectionSequenceOrder = @"sequence_order";
NSString *const FormSectionHeader = @"section_header";
NSString *const FormSectionFooter = @"section_footer";
NSString *const FormSectionTitle  = @"section_title";

#pragma mark Element Table
NSString *const ElementTable                = @"element";
NSString *const ElementId                   = @"element_id";
NSString *const ElementFieldType            = @"field_type";
NSString *const ElementFieldName            = @"field_name";
NSString *const ElementSequenceOrder        = @"sequence_order";
NSString *const ElementLabel                = @"element_label";
NSString *const ElementOriginX              = @"element_origin_x";
NSString *const ElementOriginY              = @"element_origin_y";
NSString *const ElementHeight               = @"element_height";
NSString *const ElementWidth                = @"element_width";
NSString *const ElementPageNumber           = @"element_page_number";
NSString *const ElementMinCharLimit         = @"min_char_limit";
NSString *const ElementMaxCharLimit         = @"max_char_limit";
NSString *const ElementPrintedTextFormat    = @"printed_text_format";
NSString *const ElementLinkedElementId      = @"linked_element_id";
NSString *const ElementPopUpMessage         = @"pop_up_message";
NSString *const ElementLookUpListIdNew      = @"lookup_list_id_new";
NSString *const ElementLookUpListIdExisting = @"lookup_list_id_existing";
NSString *const ElementFieldNumberNew       = @"field_no_new";
NSString *const ElementFieldNumberExisting  = @"field_no_existing";

#pragma mark SubElement Table
NSString *const SubElementTable = @"sub_element";
NSString *const SubElementId    = @"sub_element_id";

#pragma mark Certificate Table
NSString *const CertificateTable     = @"certificate";
NSString *const CertificateIdApp     = @"cert_id_app";
NSString *const CertificateId        = @"cert_id";
NSString *const CertificateName      = @"name";
NSString *const CertificateIssuedApp = @"issued_app";
NSString *const CertificateDate      = @"date";
NSString *const CertificatePdf       = @"pdf";

#pragma mark Data Table
NSString *const DataTable = @"data";
NSString *const DataIdApp = @"data_id_app";
NSString *const DataId    = @"data_id";
NSString *const DataValue = @"data";

#pragma mark DataBinary Table
NSString *const DataBinaryTable = @"data_binary";
NSString *const DataBinaryIdApp = @"data_binary_id_app";
NSString *const DataBinaryId    = @"data_binary_id";
NSString *const DataBinaryValue = @"data_binary";

#pragma mark LookUp Table
NSString *const LookUpTable         = @"lookup";
NSString *const LookUpIdApp         = @"lookup_id_app";
NSString *const LookUpId            = @"lookup_id";
NSString *const LookUpListId        = @"lookup_list_id";
NSString *const LookUpLinkedRecordIdApp = @"linked_record_id_app";
NSString *const LookUpFieldNumber   = @"field_no";
NSString *const LookUpOption        = @"option";
NSString *const LookUpDataValue     = @"data";
NSString *const LookUpSequenceOrder = @"sequence_order";
NSString *const LookUpRecordTitleColumnAlias = @"record_title";

#pragma mark Record Table
NSString *const RecordTable = @"record";
NSString *const RecordIdApp = @"record_id_app";
NSString *const RecordId    = @"record_id";

#pragma mark - App Constants
#pragma mark -

#pragma mark LoginScreen
NSString *const HudTitleSignin = @"Signin...";
NSString *const ForgotPasswordAlertTitle       = @"Forgot password";
NSString *const ForgotPasswordEmailPlaceholder = @"Please Enter Your Email Address Here";
NSString *const ForgotPasswordResetActionTitle = @"Reset your password";

NSString *const HomeBarButtonTitle = @"Home";

NSString *const ElementPdfDrawingFormat  = @"ElementPdfFormat";
NSString *const ElementPdfDrawingContent = @"ElementPdfContent";

NSString *const LoggedUserFullName = @"LoggedUserFullName";
NSString *const LoggedUserEmail    = @"LoggedUserEmail";
NSString *const LoggedUserPassword = @"LoggedUserPassword";
NSString *const LoggedUserPermissionGroup = @"LoggedUserPermissionGroup";

#pragma mark ElementCell Reuse Identifier
NSString *const ElementCellReuseIdentifierSearch      = @"ElementCellSearch";
NSString *const ElementCellReuseIdentifierTextField   = @"ElementCellTextField";
NSString *const ElementCellReuseIdentifierTextView    = @"ElementCellTextView";
NSString *const ElementCellReuseIdentifierPicker      = @"ElementCellPicker";
NSString *const ElementCellReuseIdentifierLookUp      = @"ElementCellLookUp";
NSString *const ElementCellReuseIdentifierSignature   = @"ElementCellSignature";
NSString *const ElementCellReuseIdentifierPickList    = @"ElementCellPickList";
NSString *const ElementCellReuseIdentifierSubElement  = @"ElementCellSubElement";
NSString *const ElementCellReuseIdentifierRadioButton = @"ElementCellRadioButton";
NSString *const ElementCellReuseIdentifierLine        = @"ElementCellLine";
NSString *const ElementCellReuseIdentifierTickBox     = @"ElementCellTickBox";
NSString *const ElementCellReuseIdentifierTextLabel   = @"ElementCellTextLabel";
NSString *const ElementCellReuseIdentifierPhoto       = @"ElementCellPhoto";

#pragma mark ElementCell Reuse Identifier
NSString *const ElementCellNibNameSearch      = @"SearchElementCell";
NSString *const ElementCellNibNameTextField   = @"TextFieldElementCell";
NSString *const ElementCellNibNameTextView    = @"TextViewElementCell";
NSString *const ElementCellNibNamePicker      = @"PickerElementCell";
NSString *const ElementCellNibNameLookUp      = @"LookupElementCell";
NSString *const ElementCellNibNameSignature   = @"SignatureElementCell";
NSString *const ElementCellNibNamePickList    = @"PickListElementCell";
NSString *const ElementCellNibNameSubElement  = @"SubElementCell";
NSString *const ElementCellNibNameRadioButton = @"RadioButtonElementCell";
NSString *const ElementCellNibNameLine        = @"LineElementCell";
NSString *const ElementCellNibNameTickBox     = @"TickBoxElementCell";
NSString *const ElementCellNibNameTextLabel   = @"TextLabelElementCell";
NSString *const ElementCellNibNamePhoto       = @"PhotoElementCell";

@end
