//
//  DataBinaryHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 09/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataBinaryHandler.h"

@implementation DataBinaryHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = DataBinaryTable;
        self.appIdField    = DataBinaryIdApp;
        self.serverIdField = DataBinaryId;
        self.tableColumns  = @[DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a DataBinaryModel object information into data_binary table.
- (BOOL)insertDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    FUNCTION_START;

    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", DataBinaryTable, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    
    BOOL isExecuted = [self.database executeUpdate:query, @(dataBinaryModel.dataBinaryIdApp), @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId)];
    
    FUNCTION_END;
    return isExecuted;
}

// Check for binary data into 'data_binary' table for an element of a certificate.
- (DataBinaryModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    FUNCTION_START;
    
    DataBinaryModel *dataBinaryModel = nil;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", DataBinaryTable, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
    
    [self.database open];
    
    FMResultSet *result = [self.database executeQuery:query];
    
    if ([result next])
    {
        dataBinaryModel = [DataBinaryModel new];
        [dataBinaryModel initWithResultSet:result];
    }
    
    [self.database close];
    
    FUNCTION_END;
    return dataBinaryModel;
}

// Update a DataBinaryModel object information into data_binary table.
- (BOOL)updateDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    FUNCTION_START;
    
    [self.database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", DataBinaryTable, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataBinaryIdApp];
    
    BOOL isExecuted = [self.database executeUpdate:query, @(dataBinaryModel.dataBinaryIdApp), @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId), @(dataBinaryModel.dataBinaryId)];
    
    [self.database close];
    
    FUNCTION_END;
    return isExecuted;
}

@end
