//
//  ConstantUtils.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "Constant.h"

@implementation Constant

//Common
NSString *const KeyboardWillResignNotification = @"ResignKeyboard";

NSString *const ElementPdfDrawingFormat = @"ElementPdfFormat";
NSString *const ElementPdfDrawingContent = @"ElementPdfContent";

//Table Names
NSString *const SettingTable = @"setting";
NSString *const FormTable = @"form";
NSString *const FormSectionTable = @"section";
NSString *const ElementTable = @"element";
NSString *const SubElementTable = @"sub_element";
NSString *const PickListOptionTable = @"picklist_option";
NSString *const DataTable = @"data";
NSString *const DataBinaryTable = @"data_binary";
NSString *const CertificateTable = @"certificate";
NSString *const MakeTable = @"make";
NSString *const ModelTable = @"model";
NSString *const BurnerTypeTable = @"burner_type";

//Common Columns
NSString *const ModifiedTimestampApp = @"modified_timestamp_app";
NSString *const ModifiedTimeStamp = @"modified_timeStamp";
NSString *const Archive = @"archive";
NSString *const UUid = @"uuid";
NSString *const IsDirty = @"is_dirty";
NSString *const CompanyId = @"company_id";

//Setting Table Columns
NSString *const SettingIdApp = @"setting_id_app";
NSString *const SettingEngineerName = @"engg_name";
NSString *const SettingEngineerSign = @"engg_sign";
NSString *const SettingEngineerEmail = @"engg_email";
NSString *const SettingEngineerPassword = @"engg_password";

//Form Table Columns
NSString *const FormIdApp       = @"form_id_app";
NSString *const FormId          = @"form_id";
NSString *const FormCategoryId  = @"category_id";
NSString *const FormName        = @"form_name";
NSString *const FormTitle       = @"form_title";
NSString *const FormBackgroundLayout = @"background_layout";
NSString *const FormStatus      = @"form_status";
NSString *const FormCompanyFormat = @"company_format";
NSString *const FormSequenceOrder = @"sequence_order";

//FormSection Table Columns
NSString *const FormSectionId = @"section_id";
NSString *const FormSectionName = @"name";
NSString *const FormSectionSequenceOrder = @"sequence_order";
NSString *const FormSectionHeader = @"section_header";
NSString *const FormSectionFooter = @"section_footer";
NSString *const FormSectionTitle = @"section_title";

//Element Table Columns
NSString *const ElementId                   = @"element_id";
NSString *const ElementSectionId            = @"section_id";
NSString *const ElementFormId               = @"form_id";
NSString *const ElementFieldType            = @"field_type";
NSString *const ElementFieldName            = @"field_name";
NSString *const ElementSequenceOrder        = @"sequence_order";
NSString *const ElementLabel                = @"element_label";
NSString *const ElementOriginX              = @"element_origin_x";
NSString *const ElementOriginY              = @"element_origin_y";
NSString *const ElementHeight               = @"element_height";
NSString *const ElementWidth                = @"element_width";
NSString *const ElementPageNumber           = @"element_page_number";
NSString *const ElementMinChar              = @"min_char_limit";
NSString *const ElementMaxChar              = @"max_char_limit";
NSString *const ElementPrintedTextFormat    = @"printed_text_format";
NSString *const ElementLinkedElementId      = @"linked_element_id";
NSString *const ElementPopUpMessage         = @"pop_up_message";
NSString *const ElementLookUpListIdNew      = @"lookup_list_id_new";
NSString *const ElementFieldNumberNew       = @"lookup_list_id_existing";
NSString *const ElementLookUpListIdExisting = @"field_no_existing";
NSString *const ElementFieldNumberExisting  = @"field_no_existing";

//SubElement Table Columns
NSString *const SubElementId = @"sub_element_id";

//Certificate Table Columns
NSString *const CertificateIdApp = @"cert_id_app";
NSString *const CertificateId    = @"cert_id";
NSString *const CertificateFormId = @"cert_form_id";
NSString *const CertificateName = @"name";
NSString *const CertificateIssuedApp = @"issued_app";
NSString *const CertificateDate = @"date";
NSString *const CertificatePdf = @"pdf";

//LookUp Table Columns
NSString *const LookUpIdApp         = @"lookup_id_app";
NSString *const LookUpId            = @"lookup_id";
NSString *const LookUpListId        = @"lookUpListId";
NSString *const LookUpRecordIdApp   = @"record_id_app";
NSString *const LookUpLinkedRecordIdApp   = @"linked_record_id_app";
NSString *const LookUpFieldNumber   = @"field_no";
NSString *const Options             = @"option";
NSString *const LookUpDataValue     = @"data";
NSString *const LookUpSequenceOrder = @"sequence_order";

//PickListOption Table Columns
NSString *const PickListOptionIdApp = @"option_id_app";
NSString *const PickListOptionType = @"type";
NSString *const PickListOptionName = @"option";
NSString *const PickListOptionValue = @"value";
NSString *const PickListOptionSequenceOrder = @"sequence_order";

//Data Table Columns
NSString *const DataIdApp = @"data_id_app";
NSString *const DataValue = @"data";
NSString *const DataId = @"dataId";
NSString *const RecordIdApp = @"recordIdApp";

//DataBinary Table Columns
NSString *const DataBinaryIdApp = @"data_binary_id_app";
NSString *const DataBinaryId = @"data_binary_id";
NSString *const DataBinaryValue = @"data_binary";


//BurnerType Table Column
NSString *const BurnerTypeId = @"burner_id";
NSString *const BurnerType   = @"burner_type";

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
