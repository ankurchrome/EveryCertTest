//
//  DataHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "DataModel.h"
#import "CertificateModel.h"

@interface DataHandler : BaseHandler

/**
 Insert a DataModel object information into data table.
 @param  dataModel A DataModel model containing value of an element of the form
 @return BOOL return Yes if data model saved successfully otherwise No
 */
- (BOOL)insertDataModel:(DataModel *)dataModel;

/**
 Update a DataModel object information into data table.
 @param  dataModel A DataModel model containing value of an element of the form
 @return BOOL return Yes if data model updated successfully otherwise No
 */
- (BOOL)updateDataModel:(DataModel *)dataModel;

//TODO: remove the method if not required
/**
 Check for data into 'data' table for an element of a certificate.
 @param  certIdApp App Id of certificate record
 @param  elementIdApp App Id of element record
 @return return DataModel object if data exist otherwise returns nil
 */
- (DataModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp;

/**
 Deleta all the data which are linked to given record id and associated with given certificate
 @param  recordIdApp An app id of a record
 @param  certIdApp A cert id app of a certificate
 @return void
 */
- (void)deleteLinkedDataForRecord:(NSInteger)recordIdApp certificate:(NSInteger)certIdApp;

// Fetch Data from cert_id_app , field_name, form_id in DataTable
- (NSString *)getDataFromCertModel:(CertificateModel *)certModel FieldName:(NSString *)fieldName;

// Get the linked record of given record and associated with given certificate
- (NSInteger)getLinkedRecord:(NSInteger)recordIdApp inCertificate:(NSInteger)certIdApp;

@end
