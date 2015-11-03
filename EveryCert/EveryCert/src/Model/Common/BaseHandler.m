//
//  BaseHandler.m
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler

NSString *const SyncFinishedNotification = @"SyncFinishedNotification";

// Initialized the BaseHandler object with the FMDatabase object and linked it to sqlite database stored in Document dir.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.commonTableColumns = [[NSArray alloc] initWithObjects:ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid, nil];
    }
    
    return self;
}

#pragma mark - Common Methods

- (NSString *)insertQueryForInfo:(NSDictionary *)recordInfo
{
    //Make column string to bind the column data from dictionary
    NSMutableString *columnString = [NSMutableString new];
    NSMutableString *valueString  = [NSMutableString new];
    
    for (NSString *key in self.tableColumns)
    {
        if ([recordInfo objectForKey:key])
        {
            [columnString appendFormat:@"%@, ", key];
            [valueString  appendFormat:@":%@, ", key];
        }
    }
    
    if ([columnString hasSuffix:@", "])
    {
        //remove the extra separator from the end
        [columnString deleteCharactersInRange:NSMakeRange(columnString.length-2, 2)];
    }
    
    if ([valueString hasSuffix:@", "])
    {
        //remove the extra separator from the end
        [valueString deleteCharactersInRange:NSMakeRange(valueString.length-2, 2)];
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", self.tableName, columnString, valueString];

    return query;
}

- (NSString *)updateQueryForInfo:(NSDictionary *)recordInfo
{
    if (!recordInfo) return nil;
    
    NSMutableDictionary *updatedColumnInfo = [[NSMutableDictionary alloc] initWithDictionary:recordInfo];
    
    //Make column string to bind the column data from dictionary
    NSMutableString *columnString = [NSMutableString new];
    
    for (NSString *key in [updatedColumnInfo allKeys])
    {
        [columnString appendFormat:@"%@ = :%@, ", key, key];
    }
    
    if ([columnString hasSuffix:@", "])
    {
        //remove the extra separator from the end
        [columnString deleteCharactersInRange:NSMakeRange(columnString.length-2, 2)];
    }
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = :%@", self.tableName, columnString, self.appIdField, self.appIdField];

    return query;
}

// Insert into table with columns and their data defined in the columnInfo and return the app id generated locally
- (NSInteger)insertInfo:(NSDictionary *)columnInfo
{
    __block NSInteger appId = 0;
    
    if (!columnInfo || columnInfo.count <= 0) return appId;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         //Make column string to bind the column data from dictionary
         NSMutableString *columnString = [NSMutableString new];
         NSMutableString *valueString  = [NSMutableString new];
         
         for (NSString *key in self.tableColumns)
         {
             if ([columnInfo objectForKey:key])
             {
                 [columnString appendFormat:@"%@, ", key];
                 [valueString  appendFormat:@":%@, ", key];
             }
         }
         
         if ([columnString hasSuffix:@", "])
         {
             //remove the extra separator from the end
             [columnString deleteCharactersInRange:NSMakeRange(columnString.length-2, 2)];
         }
         
         if ([valueString hasSuffix:@", "])
         {
             //remove the extra separator from the end
             [valueString deleteCharactersInRange:NSMakeRange(valueString.length-2, 2)];
         }
         
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", self.tableName, columnString, valueString];
         
         if ([db executeUpdate:query withParameterDictionary:columnInfo])
         {
             appId = [db lastInsertRowId];
         }
     }];
    
    return appId;
}

// Update into table with columns and their data defined in the columnInfo for the given recordIdApp
- (BOOL)updateInfo:(NSDictionary *)columnInfo recordIdApp:(NSInteger)recordIdApp
{
    __block BOOL success = false;
    
    if (!columnInfo || columnInfo.count <= 0 || recordIdApp <=0) return success;
        
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSMutableDictionary *updatedColumnInfo = [[NSMutableDictionary alloc] initWithDictionary:columnInfo];

         //Make column string to bind the column data from dictionary
         NSMutableString *columnString = [NSMutableString new];
         
         for (NSString *key in [updatedColumnInfo allKeys])
         {
             
             [columnString appendFormat:@"%@ = :%@, ", key, key];
         }

         if ([columnString hasSuffix:@", "])
         {
             //remove the extra separator from the end
             [columnString deleteCharactersInRange:NSMakeRange(columnString.length-2, 2)];
         }
         
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = :%@", self.tableName, columnString, self.appIdField, self.appIdField];

         [updatedColumnInfo setObject:@(recordIdApp) forKey:self.appIdField];
         success = [db executeUpdate:query withParameterDictionary:updatedColumnInfo];
     }];
    
    return success;
}

//returns local Record id for given server Id.
- (NSInteger)getAppId:(NSInteger)serverId
{
    FUNCTION_START;
    
    __block NSInteger appId = 0;
    
    if (serverId <= 0 || ![CommonUtils isValidString:self.appIdField]) return appId;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?", self.appIdField, self.tableName, self.serverIdField];
         
         FMResultSet *result = [db executeQuery:query, @(serverId)];
         
         if ([result next])
         {
             appId = [result intForColumn:self.appIdField];
         }
     }];
    
    return appId;
}

//returns server id for given app Id.
- (NSInteger)getServerId:(NSInteger)appId
{
    __block NSInteger serverId = 0;
    
    if (appId <= 0 || ![CommonUtils isValidString:self.appIdField]) return serverId;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?", self.serverIdField, self.tableName, self.appIdField];
         
         FMResultSet *result = [db executeQuery:query, @(appId)];
         
         if ([result next])
         {
             serverId = [result intForColumn:self.appIdField];
         }
     }];
    
    return serverId;
}

- (NSDictionary *)getRecordInfoWithAppId:(NSInteger)appId
{
    __block NSDictionary *recordInfo = nil;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", self.tableName, self.appIdField];
         
         FMResultSet *result = [db executeQuery:query, @(appId)];
         
         if ([result next])
         {
             recordInfo = [result resultDictionary];
         }
     }];
    
    return recordInfo;
}

#pragma mark - ServerSync Methods

#pragma mark Info

//Get the last updated sync timestamp for the table.
- (NSTimeInterval)getSyncTimestampOfTableForCompany:(NSInteger)companyId
{
    __block NSTimeInterval timeInterval = 0;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ? AND %@ = ?", SyncTimestampGet, SyncTimestampTable, SyncTimestampTableName, CompanyId];
         
         FMResultSet *result = [db executeQuery:query, self.tableName, @(companyId)];
         
         if ([result next])
         {
             timeInterval = [result doubleForColumn:SyncTimestampGet];
         }
     }];
    
    return timeInterval;
}

//Update the sync timestamp for the table after update all GET records.
- (BOOL)updateTableSyncTimestamp:(NSTimeInterval)timestamp company:(NSInteger)companyId
{
    __block BOOL isUpdated = false;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ? AND %@ = ?", SyncTimestampIdApp, SyncTimestampTable, SyncTimestampTableName, CompanyId];
         
         FMResultSet *result = [db executeQuery:query, self.tableName, @(companyId)];
         
         NSInteger timestampIdApp = 0;
         
         if ([result next])
         {
             timestampIdApp = [result intForColumn:SyncTimestampIdApp];
             
             query = [NSString stringWithFormat:@"UPDATE %@ SET %@  = ? WHERE %@ = ?", SyncTimestampTable, SyncTimestampGet, SyncTimestampIdApp];
             
             isUpdated = [db executeUpdate:query, @(timestamp), @(timestampIdApp)];
         }
         else
         {
             query = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@) VALUES(?, ?, ?)", SyncTimestampTable, CompanyId, SyncTimestampTableName, SyncTimestampGet];
             
             isUpdated = [db executeUpdate:query, @(companyId), self.tableName, @(timestamp)];
         }
     }];
    
    return isUpdated;
}

- (NSString *)getApiCallWithTimestamp:(NSTimeInterval)timestamp
{
    return [NSString stringWithFormat:@"%@?%@=%lf",self.apiName, ApiUrlParamTimestamp, timestamp];
}

//Return the list of all Created/Modified customers through app, the sync process send them to server.
- (NSArray *)getAllDirtyRecords
{
    FUNCTION_START;
    
    NSMutableArray *dirtyRecords = [NSMutableArray new];
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = 1 AND %@ = ?", self.tableName, IsDirty, CompanyId];
         
         FMResultSet *result = [db executeQuery:query, @(APP_DELEGATE.loggedUserCompanyId)];
         
         while ([result next])
         {
             [dirtyRecords addObject:[result resultDictionary]];
         }
     }];
    
    return dirtyRecords;
}

#pragma mark Sync

- (void)syncWithServer
{
    //1. get last sync timestamp & get records from server after that timestamp
    NSTimeInterval timestamp = [self getSyncTimestampOfTableForCompany:APP_DELEGATE.loggedUserCompanyId];
    
    NSString *apiCall = [self getApiCallWithTimestamp:timestamp];
    
    [self getRecordsWithApiCall:apiCall
                     retryCount:REQUEST_RETRY_COUNT
                        success:^(ECHttpResponseModel *response)
     {
         [self saveGetRecords:response.payloadInfo];
         
         [self updateTableSyncTimestamp:timestamp company:APP_DELEGATE.loggedUserCompanyId];
         
         //2. get all recently created/modified records from local and send them to server
         NSArray *dirtyRecords = [self getAllDirtyRecords];
         
         if (LOGS_ON) NSLog(@"Dirty Records(%@): %@", self.tableName, dirtyRecords);
         
         if (dirtyRecords && dirtyRecords.count > 0)
         {
             [self  putRecords:dirtyRecords
                    retryCount:REQUEST_RETRY_COUNT
                       success:^(ECHttpResponseModel *response)
              {
                  [self savePutRecords:response.payloadInfo];
                  
                  [self startNextSyncOperation];
              }
                         error:^(NSError *error)
              {
                  if (LOGS_ON) NSLog(@"Sync Failed(PUT - %@): %@", self.tableName, error.localizedDescription);
                  return;
              }];
         }
         else
         {
             [self startNextSyncOperation];
         }
     }
                          error:^(NSError *error)
     {
         [self finishSyncWithError:error];
         
         if (LOGS_ON) NSLog(@"Sync Failed(GET - %@): %@", self.tableName, error.localizedDescription);
     }];
}

#pragma mark Response

- (void)saveGetRecords:(NSArray *)records
{
    for (NSDictionary *responseInfo in records)
    {
        BOOL success = false;
        
        NSInteger serverId = [[responseInfo objectForKey:self.serverIdField] integerValue];
        NSInteger appId = [self getAppId:serverId];
        
        if (appId > 0)
        {
            NSDictionary *recordInfo = [self populateInfoForExistingRecord:responseInfo appId:appId];
            
            if (recordInfo)
            {
                success = [self updateInfo:recordInfo recordIdApp:appId];
            }
        }
        else
        {
            NSDictionary *recordInfo = [self populateInfoForNewRecord:responseInfo];
            
            if (recordInfo)
            {
                success = ([self insertInfo:recordInfo] > 0);
            }
        }
        
        if (!success)
        {
            if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", self.tableName, responseInfo);
        }
    }
}

- (void)saveGetRecordsForServerOnlyTable:(NSArray *)records
{
    for (NSDictionary *responseInfo in records)
    {
        BOOL success = false;
        
        NSInteger timestampServer = [[responseInfo valueForKey:ModifiedTimeStampServer] doubleValue];
        NSMutableDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
        [recordInfo setObject:@(timestampServer) forKey:ModifiedTimeStamp];
        
        NSInteger serverId = [[recordInfo objectForKey:self.serverIdField] integerValue];
        
        //In ServeryOnly tables there is no app id (server id is being treated as app id)
        
        if ([self getRecordInfoWithAppId:serverId])//self.appIdField & self.serverIdField will contain same column
        {
            success = [self updateInfo:recordInfo recordIdApp:serverId];
        }
        else
        {
            success = [self insertInfo:recordInfo];
        }
        
        if (!success)
        {
            if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", self.tableName, responseInfo);
        }
    }
}

- (void)savePutRecords:(NSArray *)records
{
     for (NSDictionary *responseInfo in records)
     {
         NSDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
         
         NSInteger appId = [[recordInfo objectForKey:self.appIdField] integerValue];
         
         if (appId > 0)
         {
             if (![self updateInfo:recordInfo recordIdApp:appId])
             {
                if (LOGS_ON) NSLog(@"Update Failed(PUT - %@): %@", self.tableName, recordInfo);
             }
         }
     }
}

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info
{
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimestampApp];
    }
    
    return newRecordInfo;
}

- (NSMutableDictionary *)populateInfoForExistingRecord:(NSDictionary *)info appId:(NSInteger)appId
{
    //Get all fields of table from record info
    NSMutableDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    [recordInfo setObject:@(appId) forKey:self.appIdField];
    
    // initialize modified timestamp explicitly because fields names are different
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [recordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
    }
    
    NSDictionary *appRecordInfo = [self getRecordInfoWithAppId:appId];
    BOOL isDirty = [[appRecordInfo objectForKey:IsDirty] boolValue];
    
    if (isDirty)
    {
        NSInteger timestampServer = [[recordInfo valueForKey:ModifiedTimeStamp] doubleValue];
        NSInteger timestampApp    = [[appRecordInfo valueForKey:ModifiedTimestampApp] doubleValue];
        
        //compare the local & server timestamp most recent will win.
        if (timestampServer > timestampApp)
        {
            if (LOGS_ON) NSLog(@"Server data is most recent so it will be update into local");
            
            [recordInfo setObject:@(false) forKey:IsDirty];
        }
        else
        {
            if (LOGS_ON) NSLog(@"Local record is most recently modified");
            
            recordInfo = nil;
        }
    }
    
    return recordInfo;
}

- (void)startNextSyncOperation
{
    if (self.nextSyncHandler)
    {
        [self.nextSyncHandler syncWithServer];
    }
    else
    {
        [self finishSyncWithError:nil];
    }
}

- (void)finishSyncWithError:(NSError *)error
{
    error = [[NSError alloc] initWithDomain:@"Test" code:10 userInfo:@{@"message": @"sync finished"}];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SyncFinishedNotification object:error];
    });
}

#pragma mark - NetworkService Methods

- (void)getRecordsWithApiCall:(NSString *)apiCall retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse
{
    if (retryCount <= 0)
    {
        NSDictionary *errorInfo = @{
                                    NSLocalizedDescriptionKey: @"Request Timeout"
                                    };
        NSError *error = [NSError errorWithDomain:ErrorDomainRequestFailed code:0 userInfo:errorInfo];
        
        errorResponse(error);
    };
    
    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];
    
    if (LOGS_ON) NSLog(@"Request: GET %@", apiCall);
    
    [httpClient GET:apiCall
         parameters:nil
            success:^(NSURLSessionDataTask *dataTask, id responseObject)
     {
         if (LOGS_ON) NSLog(@"Response: %@", responseObject);
         
         ECHttpResponseModel *responseModel = [[ECHttpResponseModel alloc] initWithResponseInfo:responseObject];
         
         if (responseModel.error)
         {
             errorResponse(responseModel.error);
         }
         else
         {
             successResponse(responseModel);
         }
     }
            failure:^(NSURLSessionDataTask * dataTask, NSError *error)
     {
         [self getRecordsWithApiCall:apiCall retryCount:retryCount - 1 success:successResponse error:errorResponse];
     }];
}

- (void)getRecordsWithTimestamp:(NSTimeInterval)timestamp retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse
{
    if (retryCount <= 0)
    {
        NSDictionary *errorInfo = @{
                                    NSLocalizedDescriptionKey: @"Request Timeout"
                                    };
        NSError *error = [NSError errorWithDomain:ErrorDomainRequestFailed code:0 userInfo:errorInfo];

        errorResponse(error);
    };
    
    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];
    
    NSString *apiCall = [self getApiCallWithTimestamp:timestamp];
    
    if (LOGS_ON) NSLog(@"Request: GET %@", apiCall);
    
    [httpClient GET:apiCall
         parameters:nil
            success:^(NSURLSessionDataTask *dataTask, id responseObject)
     {
         if (LOGS_ON) NSLog(@"Response: %@", responseObject);
         
         ECHttpResponseModel *responseModel = [[ECHttpResponseModel alloc] initWithResponseInfo:responseObject];
         
         if (responseModel.error)
         {
             errorResponse(responseModel.error);
         }
         else
         {
             successResponse(responseModel);
         }
     }
            failure:^(NSURLSessionDataTask * dataTask, NSError *error)
     {
         [self getRecordsWithTimestamp:timestamp retryCount:retryCount - 1 success:successResponse error:errorResponse];
     }];
}

- (void)putRecords:(NSArray *)records retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse
{
    if (retryCount <= 0)
    {
        NSDictionary *errorInfo = @{
                                    NSLocalizedDescriptionKey: @"Request Timeout"
                                    };
        NSError *error = [NSError errorWithDomain:ErrorDomainRequestFailed code:0 userInfo:errorInfo];
        
        errorResponse(error);
    };

    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];
    
    if (LOGS_ON) NSLog(@"Request: PUT %@", self.apiName);
    
    [httpClient PUT:self.apiName
         parameters:records
            success:^(NSURLSessionDataTask *dataTask, id responseObject)
     {
         if (LOGS_ON) NSLog(@"Response: %@", responseObject);
         
         ECHttpResponseModel *responseModel = [[ECHttpResponseModel alloc] initWithResponseInfo:responseObject];
         
         if (responseModel.error)
         {
             errorResponse(responseModel.error);
         }
         else
         {
             successResponse(responseModel);
         }
     }
            failure:^(NSURLSessionDataTask * dataTask, NSError *error)
     {
         [self putRecords:records retryCount:retryCount - 1 success:successResponse error:errorResponse];
     }];
}


//- (void)saveGetRecords:(NSArray *)records
//{
//    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
//    
//    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
//     {
//         for (NSDictionary *responseInfo in records)
//         {
//             NSInteger timestampServer = [[responseInfo valueForKey:ModifiedTimeStampServer] doubleValue];
//             
//             //No need to check modified data in local for tables which could not be modified through the app
//             if (self.noLocalRecord)
//             {
//                 NSMutableDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
//                 [recordInfo setObject:@(timestampServer) forKey:ModifiedTimeStamp];
//                 
//                 NSInteger serverId = [[recordInfo objectForKey:self.serverIdField] integerValue];
//                 
//                 NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", self.tableName, self.serverIdField];
//                 
//                 FMResultSet *result = [db executeQuery:query, @(serverId)];
//                 
//                 if ([result next])
//                 {
//                     query = [self updateQueryForInfo:recordInfo];
//                 }
//                 else
//                 {
//                     query = [self insertQueryForInfo:recordInfo];
//                 }
//                 
//                 if (![db executeUpdate:query withParameterDictionary:recordInfo])
//                 {
//                     if (LOGS_ON) NSLog(@"Insert/Update Failed(GET - %@): %@", self.tableName, recordInfo);
//                 }
//                 
//                 continue;
//             }
//             
//             NSInteger serverId = [[responseInfo objectForKey:self.serverIdField] integerValue];
//             
//             NSInteger appId = 0;
//             
//             if (serverId > 0 || [CommonUtils isValidString:self.appIdField])
//             {
//                 NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?", self.appIdField, self.tableName, self.serverIdField];
//                 
//                 FMResultSet *result = [db executeQuery:query, @(serverId)];
//                 
//                 if ([result next])
//                 {
//                     appId = [result intForColumn:self.appIdField];
//                 }
//             }
//             
//             if (appId <= 0)
//             {
//                 //Get info from response for fields which are available in the table
//                 NSDictionary *recordInfo = [self populateInfoForNewRecord:responseInfo];
//                 
//                 NSString *query = [self insertQueryForInfo:recordInfo];
//                 
//                 if (![db executeUpdate:query withParameterDictionary:recordInfo])
//                 {
//                     if (LOGS_ON) NSLog(@"Insert Failed(GET - %@): %@", self.tableName, recordInfo);
//                 }
//             }
//             else
//             {
//                 //Get all fields of table from record info
//                 NSMutableDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
//                 [recordInfo setObject:@(appId) forKey:self.appIdField];
//                 [recordInfo setObject:@(timestampServer) forKey:ModifiedTimeStamp];
//                 
//                 if ([self.tableName isEqualToString:CertificateTable] && [responseInfo valueForKey:CertificateIssued])
//                 {
//                     [recordInfo setObject:[recordInfo valueForKey:CertificateIssued] forKey:CertificateIssuedApp];
//                 }
//                 
//                 NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", self.tableName, self.appIdField];
//                 
//                 FMResultSet *result = [db executeQuery:query, @(appId)];
//                 
//                 if (![result next]) continue;
//                 
//                 NSDictionary *appRecordInfo = [result resultDictionary];
//                 BOOL isDirty = [[appRecordInfo objectForKey:IsDirty] boolValue];
//                 
//                 if (isDirty)
//                 {
//                     NSInteger timestampServer = [[recordInfo valueForKey:ModifiedTimeStamp] doubleValue];
//                     NSInteger timestampApp    = [[appRecordInfo valueForKey:ModifiedTimestampApp] doubleValue];
//                     
//                     //compare the local & server timestamp most recent will win.
//                     if (timestampServer > timestampApp)
//                     {
//                         if (LOGS_ON) NSLog(@"Server data is most recent so it will be update into local");
//                         
//                         [recordInfo setObject:@(false) forKey:IsDirty];
//                         
//                         NSString *query = [self updateQueryForInfo:recordInfo];
//                         
//                         if (![db executeUpdate:query withParameterDictionary:recordInfo])
//                         {
//                             if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", self.tableName, recordInfo);
//                         }
//                     }
//                 }
//                 else
//                 {
//                     NSString *query = [self updateQueryForInfo:recordInfo];
//                     
//                     if (![db executeUpdate:query withParameterDictionary:recordInfo])
//                     {
//                         if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", self.tableName, recordInfo);
//                     }
//                 }
//             }
//         }
//     }];
//}
//
//- (void)savePutRecords:(NSArray *)records
//{
//    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
//    
//    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
//     {
//         for (NSDictionary *responseInfo in records)
//         {
//             NSDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
//             
//             NSInteger appId = [[recordInfo objectForKey:self.appIdField] integerValue];
//             
//             if (appId > 0)
//             {
//                 NSString *query = [self updateQueryForInfo:recordInfo];
//                 
//                 if (![db executeUpdate:query withParameterDictionary:recordInfo])
//                 {
//                     if (LOGS_ON) NSLog(@"Update Failed(PUT - %@): %@", self.tableName, recordInfo);
//                 }
//             }
//         }
//     }];
//}
@end