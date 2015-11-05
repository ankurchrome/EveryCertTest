//
//  DataHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataHandler.h"
#import "CertificateHandler.h"
#import "RecordHandler.h"

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
        self.apiName       = ApiData;
        self.tableColumns  = @[DataIdApp, DataId, FormId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a DataModel object information into data table.
- (BOOL)insertDataModel:(DataModel *)dataModel
{
    FUNCTION_START;
    __block BOOL success = false;
    
    dataModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataModel.isDirty = true;
    dataModel.uuid = [[NSUUID new] UUIDString];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", self.tableName, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
         
         success = [db executeUpdate:query, @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, @(dataModel.modifiedTimestampApp), @(dataModel.modifiedTimestamp), @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId)];
         
         if (success)
         {
             dataModel.dataIdApp = [db lastInsertRowId];
         }
     }];
    
    FUNCTION_END;
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
    
    dataModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataModel.isDirty = true;

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, DataId, CertificateIdApp, ElementId, RecordIdApp, DataValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataIdApp];
         
         success = [db executeUpdate:query, @(dataModel.dataId), @(dataModel.certificateIdApp), @(dataModel.elementId), @(dataModel.recordIdApp), dataModel.data, dataModel.modifiedTimestampApp, dataModel.modifiedTimestamp, @(dataModel.archive), dataModel.uuid, @(dataModel.isDirty), @(dataModel.companyId), @(dataModel.dataIdApp)];
     }];
    
    return success;
}

// Deleta all the data which are linked to given record id and associated with given certificate
- (void)deleteLinkedDataForRecord:(NSInteger)recordIdApp certificate:(NSInteger)certIdApp
{
    [self deleteDataForRecord:recordIdApp cert:certIdApp];
    
    NSInteger linkedRecordIdApp = [self getLinkedRecord:recordIdApp inCertificate:certIdApp];
    
    if (linkedRecordIdApp > 0)
    {
        [self deleteLinkedDataForRecord:linkedRecordIdApp certificate:certIdApp];
    }
}

// Delete the data of given record and associated with given certificate
- (BOOL)deleteDataForRecord:(NSInteger)recordIdApp cert:(NSInteger)certIdApp
{
    __block BOOL success = false;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ?", self.tableName, RecordIdApp, CertificateIdApp];
         
         success = [db executeUpdate:query, @(recordIdApp), @(certIdApp)];
     }];
    
    return success;
}

// Get the linked record of given record and associated with given certificate
- (NSInteger)getLinkedRecord:(NSInteger)recordIdApp inCertificate:(NSInteger)certIdApp
{
    __block NSInteger linkedRecordIdApp = 0;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ WHERE %@ = ? AND %@ in (SELECT DISTINCT %@ FROM %@ WHERE %@ = ?)", RecordIdApp, self.tableName, CertificateIdApp, RecordIdApp, RecordIdApp, LookUpTable, LookUpLinkedRecordIdApp];

         FMResultSet *result = [db executeQuery:query, @(certIdApp), @(recordIdApp)];
         
         if ([result next])
         {
             linkedRecordIdApp = [result intForColumn:RecordIdApp];
         }
     }];
    
    return linkedRecordIdApp;
}

#pragma mark - ServerSync Methods

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info
{
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];

    //Save cert id app
    CertificateHandler *certificateHandler = [CertificateHandler new];
    certificateHandler.db = self.db;
    NSInteger certificateId = [info[CertificateId] integerValue];
    NSInteger certificateIdApp = certificateId > 0 ? [certificateHandler getAppId:certificateId] : 0;
    
    if (certificateIdApp <= 0)
    {
        if (LOGS_ON) NSLog(@"Certificate not found: %ld", certificateIdApp); return nil;
    }

    [newRecordInfo setObject:@(certificateIdApp).stringValue forKey:CertificateIdApp];
    
    //Save record id app
    RecordHandler *recordHandler = [RecordHandler new];
    recordHandler.db = self.db;
    NSInteger recordId = [info[RecordId] integerValue];
    NSInteger recordIdApp = recordId > 0 ? [recordHandler getAppId:recordId] : 0;
    [newRecordInfo setObject:@(recordIdApp).stringValue forKey:RecordIdApp];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimestampApp];
    }
    
    return newRecordInfo;
}

- (NSString *)getDataFromCertModel:(CertificateModel *)certModel FieldName:(NSString *)fieldName
{
    __block NSString *data = [NSString new];
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         //SELECT data FROM data where cert_id_app = 82 and element_id = (select element_id from element where field_name = 'customer_name' and form_id = '1007')
         NSString *query = [NSString stringWithFormat: @"SELECT %@ FROM %@ where %@ = ? and %@ = (select %@ from %@ where %@ = ? and %@ = ?)", DataValue, DataTable, CertificateIdApp, ElementId, ElementId, ElementTable, ElementFieldName, FormId];
         
         FMResultSet *result = [db executeQuery:query, @(certModel.certIdApp), fieldName, @(certModel.formId)];
         
         if ([result next])
         {
             data = [result stringForColumn: DataValue];
         }
     }];
    
    return data;
}

@end
