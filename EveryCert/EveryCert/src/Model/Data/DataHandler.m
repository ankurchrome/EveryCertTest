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
    __block BOOL success = false;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", self.tableName, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
         
         success = [db executeUpdate:query, @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, dataModel.modifiedTimestampApp, dataModel.modifiedTimestamp, @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId)];
     }];
    
    return success;
}

// Check for data into 'data' table for an element of a certificate.
- (DataModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    __block DataModel *dataModel = nil;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", self.tableName, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
         
         FMResultSet *result = [db executeQuery:query];
         
         if ([result next])
         {
             dataModel = [[DataModel alloc] initWithResultSet:result];
         }
     }];
    
    return dataModel;
}

// Update a DataModel object information into data table.
- (BOOL)updateDataModel:(DataModel *)dataModel
{
    __block BOOL success = false;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataIdApp];
         
         success = [db executeUpdate:query, @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, dataModel.modifiedTimestampApp, dataModel.modifiedTimestamp, @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId), @(dataModel.dataIdApp)];
     }];
    
    return success;
}

@end
