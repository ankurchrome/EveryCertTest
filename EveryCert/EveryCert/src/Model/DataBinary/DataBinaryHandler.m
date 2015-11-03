//
//  DataBinaryHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 09/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataBinaryHandler.h"
#import "CertificateHandler.h"
#import "RecordHandler.h"

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
        self.apiName       = ApiDataBinary;
        self.tableColumns  = @[DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a DataBinaryModel object information into data_binary table.
- (BOOL)insertDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    __block BOOL success = false;
    
    dataBinaryModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataBinaryModel.isDirty = true;
    dataBinaryModel.uuid = [[NSUUID new] UUIDString];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", self.tableName, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
         
         success = [db executeUpdate:query, @(dataBinaryModel.dataBinaryIdApp), @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId)];
     }];
    
    return success;
}

// Check for binary data into 'data_binary' table for an element of a certificate.
- (DataBinaryModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    FUNCTION_START;
    
    __block DataBinaryModel *dataBinaryModel = nil;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", self.tableName, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
         
         FMResultSet *result = [db executeQuery:query];
         
         if ([result next])
         {
             dataBinaryModel = [[DataBinaryModel alloc] initWithResultSet:result];
         }
     }];
    
    return dataBinaryModel;
}

// Update a DataBinaryModel object information into data_binary table.
- (BOOL)updateDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    __block BOOL success = false;
    
    dataBinaryModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataBinaryModel.isDirty = true;

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataBinaryIdApp];
         
         success = [db executeUpdate:query, @(dataBinaryModel.dataBinaryIdApp), @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId), @(dataBinaryModel.dataBinaryId)];
     }];
    
    return success;
}

#pragma mark - ServerSync Methods

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info
{
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    //Save cert id app
    CertificateHandler *certificateHandler = [CertificateHandler new];
    NSInteger certificateId = [info[CertificateId] integerValue];
    NSInteger certificateIdApp = certificateId > 0 ? [certificateHandler getAppId:certificateId] : 0;
    
    if (certificateIdApp <= 0)
    {
        if (LOGS_ON) NSLog(@"Certificate not found: %ld", certificateId); return nil;
    }
    
    [newRecordInfo setObject:@(certificateIdApp).stringValue forKey:CertificateIdApp];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimestampApp];
    }
    
    return newRecordInfo;
}

@end
