//
//  DataBinaryHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 09/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "DataBinaryModel.h"

@interface DataBinaryHandler : BaseHandler

/**
 Insert a DataBinaryModel object information into data_binary table.
 @param  dataBinaryModel A DataBinaryModel model containing data of signatio
 @return BOOL return Yes if data model saved successfully otherwise No
 */
- (BOOL)insertDataBinaryModel:(DataBinaryModel *)dataBinaryModel;

/**
 Check for binary data into 'data_binary' table for an element of a certificate.
 @param  certIdApp App Id of certificate record
 @param  elementIdApp App Id of element record
 @return return DataBinaryModel object if data exist otherwise returns nil
 */
- (DataBinaryModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp;

/**
 Update a DataBinaryModel object information into data_binary table.
 @param  dataBinaryModel A DataBinaryModel model containing data of signatio
 @return BOOL return Yes if data model updated successfully otherwise No
 */
- (BOOL)updateDataBinaryModel:(DataBinaryModel *)dataBinaryModel;


@end
