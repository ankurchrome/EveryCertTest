//
//  ConstantUtils.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "Constant.h"

@implementation Constant

NSString *const HomeBarButtonTitle = @"Home";

//Common
NSString *const KeyboardWillResignNotification = @"ResignKeyboard";

NSString *const ElementPdfDrawingFormat  = @"ElementPdfFormat";
NSString *const ElementPdfDrawingContent = @"ElementPdfContent";

//Common Columns
NSString *const ModifiedTimestampApp = @"modified_timestamp_app";
NSString *const ModifiedTimeStamp    = @"modified_timeStamp";
NSString *const Archive   = @"archive";
NSString *const Uuid      = @"uuid";
NSString *const IsDirty   = @"is_dirty";
NSString *const CompanyId = @"company_id";
NSString *const UserId    = @"user_id";

//CompanyUser Table
NSString *const CompanyUserTable     = @"company_user";
NSString *const CompanyUserIdApp     = @"company_user_id_app";
NSString *const CompanyUserId        = @"company_user_id";
NSString *const CompanyUserFieldName = @"field_name";
NSString *const CompanyUserData      = @"data";

//Form Table
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

//FormSection Table
NSString *const FormSectionTable  = @"section";
NSString *const FormSectionId     = @"section_id";
NSString *const FormSectionLabel  = @"section_label";
NSString *const FormSectionSequenceOrder = @"sequence_order";
NSString *const FormSectionHeader = @"section_header";
NSString *const FormSectionFooter = @"section_footer";
NSString *const FormSectionTitle  = @"section_title";

//Element Table
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

//SubElement Table
NSString *const SubElementTable = @"sub_element";
NSString *const SubElementId    = @"sub_element_id";

//Certificate Table
NSString *const CertificateTable     = @"certificate";
NSString *const CertificateIdApp     = @"cert_id_app";
NSString *const CertificateId        = @"cert_id";
NSString *const CertificateName      = @"name";
NSString *const CertificateIssuedApp = @"issued_app";
NSString *const CertificateDate      = @"date";
NSString *const CertificatePdf       = @"pdf";

//Data Table
NSString *const DataTable = @"data";
NSString *const DataIdApp = @"data_id_app";
NSString *const DataId    = @"dataId";
NSString *const DataValue = @"data";

//DataBinary Table
NSString *const DataBinaryTable = @"data_binary";
NSString *const DataBinaryIdApp = @"data_binary_id_app";
NSString *const DataBinaryId    = @"data_binary_id";
NSString *const DataBinaryValue = @"data_binary";

//LookUp Table
NSString *const LookUpTable         = @"lookup";
NSString *const LookUpIdApp         = @"lookup_id_app";
NSString *const LookUpId            = @"lookup_id";
NSString *const LookUpListId        = @"lookup_list_id";
NSString *const LookUpRecordIdApp   = @"record_id_app";
NSString *const LookUpLinkedRecordIdApp = @"linked_record_id_app";
NSString *const LookUpFieldNumber   = @"field_no";
NSString *const LookUpOption        = @"option";
NSString *const LookUpDataValue     = @"data";
NSString *const LookUpSequenceOrder = @"sequence_order";

//Record Table
NSString *const RecordTable = @"record";
NSString *const RecordIdApp = @"record_id_app";
NSString *const RecordId    = @"record_id";


























//Table Names
NSString *const SettingTable = @"setting";
NSString *const PickListOptionTable = @"picklist_option";
NSString *const MakeTable = @"make";
NSString *const ModelTable = @"model";
NSString *const BurnerTypeTable = @"burner_type";

//Common Columns


//Setting Table Columns
NSString *const SettingIdApp = @"setting_id_app";
NSString *const SettingEngineerName = @"engg_name";
NSString *const SettingEngineerSign = @"engg_sign";
NSString *const SettingEngineerEmail = @"engg_email";
NSString *const SettingEngineerPassword = @"engg_password";

//Form Table Columns

//FormSection Table Columns


//Element Table Columns


//SubElement Table Columns


//Certificate Table Columns


//LookUp Table Columns


//PickListOption Table Columns
NSString *const PickListOptionIdApp = @"option_id_app";
NSString *const PickListOptionType = @"type";
NSString *const PickListOptionName = @"option";
NSString *const PickListOptionValue = @"value";
NSString *const PickListOptionSequenceOrder = @"sequence_order";

//Data Table Columns

//DataBinary Table Columns



//BurnerType Table Column
NSString *const BurnerTypeId = @"burner_id";
NSString *const BurnerType   = @"burner_type";

//Elements Reuse Identifier
NSString *const TextViewCustomCell      = @"TextViewCustomCell";
NSString *const TickBoxCustomCell       = @"TickBoxCustomCell";
NSString *const TextLabelCustomCell     = @"TextLabelCustomCell";
NSString *const TextFieldCustomCell     = @"TextFieldCustomCell";
NSString *const SubElementsCustomCell   = @"SubElementsCustomCell";
NSString *const SignatureViewCustomCell = @"SignatureViewCustomCell";
NSString *const RadioButtonsCustomCell  = @"RadioButtonsCustomCell";
NSString *const LookUpCustomCell        = @"LookUpCustomCell";
NSString *const PickListCustomCell      = @"PickListCustomCell";


//Elements Reuse Identifier
NSString *const TextViewReuseIdentifier        = @"TextViewCustomCell";
NSString *const TickBoxReuseIdentifier         = @"TickBoxCustomCell";
NSString *const TextLabelReuseIdentifier       = @"TextLabelCustomCell";
NSString *const TextFieldReuseIdentifier       = @"TextFieldCustomCell";
NSString *const SubElementsReuseIdentifier     = @"SubElementsCustomCell";
NSString *const SignatureViewReuseIdentifier   = @"SignatureViewCustomCell";
NSString *const RadioButtonsReuseIdentifier  = @"RadioButtonsCustomCell";
NSString *const LookUpReuseIdentifier          = @"LookUpCustomCell";
NSString *const PickListReuseIdentifier        = @"PickListCustomCell";

@end
