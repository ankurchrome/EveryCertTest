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
        self.tableName  = DataBinaryTable;
        self.appIdField = DataBinaryIdApp;
        self.fieldList  = [[NSArray alloc] initWithObjects:DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId, nil];
    }
    
    return self;
}

// Insert a DataBinaryModel object information into data_binary table.
- (BOOL)insertDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    FUNCTION_START;
    
    [_database open];

    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", DataBinaryTable, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId];
    
    BOOL isExecuted = [_database executeUpdate:query, @(dataBinaryModel.dataIdApp), @(dataBinaryModel.dataId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId)];
    
    [_database close];
    
    FUNCTION_END;
    return isExecuted;
}

// Check for binary data into 'data_binary' table for an element of a certificate.
- (DataBinaryModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    FUNCTION_START;
    
    DataBinaryModel *dataBinaryModel = nil;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", DataBinaryTable, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
    
    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];
    
    if ([result next])
    {
        dataBinaryModel = [DataBinaryModel new];
        [dataBinaryModel initWithResultSet:result];
    }
    
    [_database close];
    
    FUNCTION_END;
    return dataBinaryModel;
}

// Update a DataBinaryModel object information into data_binary table.
- (BOOL)updateDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    FUNCTION_START;
    
    [_database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", DataBinaryTable, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId, DataBinaryIdApp];
    
    BOOL isExecuted = [_database executeUpdate:query, @(dataBinaryModel.dataIdApp), @(dataBinaryModel.dataId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId), @(dataBinaryModel.dataIdApp)];
    
    [_database close];
    
    FUNCTION_END;
    return isExecuted;
}

@end
