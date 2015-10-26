//
//  BaseHandler.m
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler

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

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info
{
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStamp])
    {
        [newRecordInfo setValue:[info valueForKey:ModifiedTimeStamp] forKey:ModifiedTimestampApp];
    }
    
    return newRecordInfo;
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

#pragma mark - NetworkService Methods

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
    
    NSString *apiCall = [NSString stringWithFormat:@"%@?%@=%lf",self.apiName, ApiUrlParamTimestamp, timestamp];
    
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

@end