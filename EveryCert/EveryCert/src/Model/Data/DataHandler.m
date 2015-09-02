//
//  DataHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataHandler.h"

@implementation DataHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = DataTable;
        self.appIdField    = DataIdApp;
        self.serverIdField = DataId;
        self.tableColumns  = @[DataIdApp, DataId, FormId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a DataModel object information into data table.
- (BOOL)insertDataModel:(DataModel *)dataModel
{
    FUNCTION_START;
    
    [self.database open];
    
//    data_id_app INTEGER N P
//    data_id INTEGER N D
//    cert_id_app INTEGER N D
//    element_id INTEGER N D
//    record_id_app INTEGER N D
//    data TEXT N D
//    modified_timestamp_app TEXT N D
//    modified_timestamp TEXT N D
//    archive INTEGER N D
//    uuid TEXT N D
//    is_dirty INTEGER N D
//    company_id INTEGER N
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", DataTable, DataIdApp, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    
    BOOL isExecuted = [self.database executeUpdate:query, @(dataModel.dataIdApp), @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, dataModel.modifiedTimestampApp, dataModel.modifiedTimestamp, @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId)];
    
    [self.database close];
    
    FUNCTION_END;
    return isExecuted;
}

// Check for data into 'data' table for an element of a certificate.
- (DataModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    FUNCTION_START;
    
    DataModel *dataModel = nil;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", DataTable, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
    
    [self.database open];
    
    FMResultSet *result = [self.database executeQuery:query];
    
    if ([result next])
    {
        dataModel = [DataModel new];
        [dataModel initWithResultSet:result];
    }
    
    [self.database close];
    
    FUNCTION_END;
    return dataModel;
}

// Update a DataModel object information into data table.
- (BOOL)updateDataModel:(DataModel *)dataModel
{
    FUNCTION_START;
    
    [self.database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", DataTable, DataIdApp, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataIdApp];
    
    BOOL isExecuted = [self.database executeUpdate:query, @(dataModel.dataIdApp), @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, dataModel.modifiedTimestampApp, dataModel.modifiedTimestamp, @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId), @(dataModel.dataIdApp)];
    
    [self.database close];
    
    FUNCTION_END;
    return isExecuted;
}

@end
