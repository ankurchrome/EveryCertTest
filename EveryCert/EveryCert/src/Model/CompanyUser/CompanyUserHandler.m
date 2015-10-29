//
//  CompanyUserHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CompanyUserHandler.h"
#import "ElementModel.h"

@implementation CompanyUserHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];

    if (self)
    {
        self.tableName     = CompanyUserTable;
        self.appIdField    = CompanyUserIdApp;
        self.serverIdField = CompanyUserId;
        self.apiName       = ApiCompanyUser;
        self.tableColumns  = @[CompanyUserIdApp, CompanyUserId, CompanyId, UserId, CompanyUserFieldName, CompanyUserData, ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid];
    }
    
    return self;
}

#pragma mark - DatabaseService Methods

// Insert a CompanyUserModel object information into company_user table
- (BOOL)insertCompanyUser:(CompanyUserModel *)companyUser
{
    __block BOOL success = false;
    
    companyUser.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    companyUser.isDirty = true;
    companyUser.uuid = [[NSUUID new] UUIDString];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?)", self.tableName, CompanyUserId, CompanyId, UserId, CompanyUserFieldName, CompanyUserData, ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid];
         
         success = [db executeUpdate:query, @(companyUser.companyUserId), @(companyUser.companyId), @(companyUser.userId), companyUser.fieldName, companyUser.data, @(companyUser.modifiedTimestampApp), @(companyUser.modifiedTimestamp), @(companyUser.archive), @(companyUser.isDirty), companyUser.uuid];
     }];
    
    return success;
}

// Update a CompanyUserModel object information into company_user table.
- (BOOL)updateCompanyUser:(CompanyUserModel *)companyUser
{
    __block BOOL success = false;
    
    companyUser.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    companyUser.isDirty = true;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, CompanyUserId, CompanyId, UserId, CompanyUserFieldName, CompanyUserData, ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid, CompanyUserIdApp];
         
         success = [db executeUpdate:query, @(companyUser.companyUserId), @(companyUser.companyId), @(companyUser.userId), companyUser.fieldName, companyUser.data, companyUser.modifiedTimestampApp, companyUser.modifiedTimestamp, @(companyUser.archive), @(companyUser.isDirty), companyUser.uuid, @(companyUser.companyUserIdApp)];
     }];
    
    return success;
}

// Check login at the app with given elements
- (BOOL)checkLoginWithElements:(NSArray *)elements
{
    __block BOOL success = true;
    __block NSInteger userId = 0;
    
    for (ElementModel *element in elements)
    {
        FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
        
        [databaseQueue inDatabase:^(FMDatabase *db)
        {
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'", self.tableName, CompanyUserFieldName, element.fieldName, CompanyUserData, element.dataValue];

            FMResultSet *result = [db executeQuery:query];
            
            if ([result next])
            {
                userId = [result intForColumn:UserId];
            }
            else
            {
                success = false;
            }
        }];
        
        if (!success) break;
    }
    
    if (success && userId > 0)
    {
        [self saveLoggedUser:userId];
    }
    
    return success;
}

//Fetch logged user data from database and store it so it can be use throughout the app
- (void)saveLoggedUser:(NSInteger)userId
{
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *query = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@ = %ld", CompanyId, CompanyUserFieldName, CompanyUserData, self.tableName, UserId, (long)userId];
        
        FMResultSet *resultSet = [db executeQuery:query];
        
        while ([resultSet next])
        {
            NSInteger companyId = [resultSet intForColumn:CompanyId];
            NSString *fieldName = [resultSet stringForColumn:CompanyUserFieldName];
            NSString *fieldData = [resultSet stringForColumn:CompanyUserData];
            
            APP_DELEGATE.loggedUserId = userId;
            APP_DELEGATE.loggedUserCompanyId = companyId;
            
            [userDefault setInteger:userId    forKey:UserId];
            [userDefault setInteger:companyId forKey:CompanyId];
            
            if (![CommonUtils isValidString:fieldData]) continue;
                
            if ([fieldName isEqualToString:CompanyUserFieldNameEmail])
            {
                APP_DELEGATE.loggedUserEmail = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserEmail];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNamePassword])
            {
                APP_DELEGATE.loggedUserPassword = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserPassword];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNameFullName])
            {
                APP_DELEGATE.loggedUserFullName = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserFullName];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNamePermissionGroup])
            {
                APP_DELEGATE.loggedUserPermissionGroup = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserPermissionGroup];
            }
        }
        
        [userDefault synchronize];
    }];
}

- (void)saveCompanyUserFields:(NSArray *)companyUserFields
{
    NSString *databasePath = [[CommonUtils getDocumentDirPath] stringByAppendingPathComponent:DATABASE_NAME];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    [database open];
    
    for (NSDictionary *companyUserFieldInfo in companyUserFields)
    {
        NSInteger companyUserId = [[companyUserFieldInfo objectForKey:CompanyUserId] integerValue];
        
        if (companyUserId <= 0) continue;
        
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?", CompanyUserIdApp, self.tableName, CompanyUserId];
         
         FMResultSet *resultSet = [database executeQuery:query, @(companyUserId)];
         
         if ([resultSet next])
         {
             NSInteger companyUserIdApp = [resultSet intForColumn:CompanyUserIdApp];
             
             [self updateInfo:companyUserFieldInfo recordIdApp:companyUserIdApp];
         }
         else
         {
             [self insertInfo:companyUserFieldInfo];
         }
    }
}

#pragma mark - SyncOperations

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
                  if (LOGS_ON) NSLog(@"Sync Failed(PUT - %@): %@", operation.tableName, error.localizedDescription);
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
         if (LOGS_ON) NSLog(@"Sync Failed(GET - %@): %@", operation.tableName, error.localizedDescription);
         return;
     }];
}

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
             
             success = [self updateInfo:recordInfo recordIdApp:appId];
         }
         else
         {
             NSDictionary *recordInfo = [self populateInfoForNewRecord:responseInfo];

             success = ([self insertInfo:recordInfo] > 1);
         }
     }
}

- (void)savePutRecords:(NSArray *)records
{
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         for (NSDictionary *responseInfo in records)
         {
             NSDictionary *recordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:responseInfo];
             
             NSInteger appId = [[recordInfo objectForKey:self.appIdField] integerValue];
             
             if (appId > 0)
             {
                 NSString *query = [self updateQueryForInfo:recordInfo];
                 
                 if (![db executeUpdate:query withParameterDictionary:recordInfo])
                 {
                     if (LOGS_ON) NSLog(@"Update Failed(PUT - %@): %@", self.tableName, recordInfo);
                 }
             }
         }
     }];
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
    }
    
    return recordInfo;
}

#pragma mark - NetworkService Methods

- (void)loginWithCredentials:(id)loginCredentials onSuccess:(SuccessCallback)successResponse onError:(ErrorCallback)errorResponse
{
    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];

    [httpClient PUT:ApiLogin
         parameters:loginCredentials
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

- (void)signupWithInfo:(id)signupInfo onSuccess:(SuccessCallback)successResponse onError:(ErrorCallback)errorResponse
{
    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];
    
    [httpClient PUT:ApiSignup
         parameters:signupInfo
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

- (void)logoutUserSuccess:(SuccessCallback)successResponse onError:(ErrorCallback)errorResponse
{
    ECHttpClient *httpClient = [ECHttpClient sharedHttpClient];
    
    [httpClient GET:ApiLogout
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
