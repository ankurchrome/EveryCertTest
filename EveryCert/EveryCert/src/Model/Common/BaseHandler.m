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

//this function will create dynamic query from update information for a given table may have condition string
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo havingConditionStatement: (NSString *)conditionString
{
    FUNCTION_START;
    
    NSString *query = [self updateQueryForTable:tableName withColumnInfo:columnInfo];
    
    if (![CommonUtils isValidString:query]) return nil;
    
    NSMutableString *queryWithCondition = [NSMutableString stringWithString:query];
    
    if ([CommonUtils isValidString:conditionString])
    {
        [queryWithCondition appendFormat:@" %@ ", conditionString];
    }
    
    FUNCTION_END;
    return queryWithCondition;
}

//this function will create dynamic query from update information for a given table.
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo
{
    FUNCTION_START;

    NSMutableString *columnsListString = nil;
    NSArray  *columnsArray = nil;
    NSString *query        = nil;
    NSString *column       = nil;
    
    if (!columnInfo) return nil;
    
    columnsArray = [columnInfo allKeys];
    
    if (columnsArray && columnsArray.count > 0)
    {
        column = [columnsArray objectAtIndex:0];
        NSString *value = [columnInfo objectForKey:column];
        
        if ([value respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
        {
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            columnsListString = [NSMutableString stringWithFormat:@"'%@'='%@'", column, value];
        }
        
        for (int i = 1; i < [columnsArray count]; i ++)
        {
            column = [columnsArray objectAtIndex:i];
            value  = [columnInfo objectForKey:column];
            
            if ([value respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                [columnsListString appendFormat:@", '%@'='%@'", column, value];
            }
        }
    }
    
    query = [NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, columnsListString];
    
    return query;
    FUNCTION_END;
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

- (void)syncWithServer
{
    //1. get last sync timestamp & get records from server after that timestamp
    NSTimeInterval timestamp = [self getSyncTimestampOfTableForCompany:APP_DELEGATE.loggedUserCompanyId];
    
    [self getRecordsWithTimestamp:timestamp
                          success:^(ECHttpResponseModel *response)
    {
    }
                            error:^(NSError *error)
    {
    }];
    
    //2. get all recently created/modified records from local & send to server
    NSArray *recordList = [self getAllDirtyRecords];
    
    for (NSMutableDictionary *recordInfo in recordList)
    {
        NSInteger recordId = [[recordInfo valueForKey:self.serverIdField] integerValue];
        
        //Check dirty record whether it is newly created or updated
        if (recordId == 0)
            isSuccess = [self postRecordWithInfo:recordInfo];
        else
        {
            if (self.isFirstCertificateCall)
            {
                continue;
            }
            
            isSuccess = [self putRecordWithInfo:recordInfo recordId:recordId];
        }
        
        //        if (!isSuccess)
        //            return isSuccess;
    }
    
    [_con beginTransaction];
    
    for (NSString *query in self.updateBulkRecords)
    {
        [_con executeQuery:query];
    }
    
    [_con commitTransaction];
    
    [self.freshBulkRecords removeAllObjects];
    [self.updateBulkRecords removeAllObjects];
    
    isSuccess = true;
    [_con connectionClose];
    
    FUNCTION_END;
    return isSuccess;
    
}

- (void)getRecordsWithTimestamp:(NSTimeInterval)timestamp success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse
{
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
         errorResponse(error);
     }];
}

@end