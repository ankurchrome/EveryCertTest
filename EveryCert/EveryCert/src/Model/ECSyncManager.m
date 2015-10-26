//
//  ECSyncManager.m
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ECSyncManager.h"
#import "CompanyUserHandler.h"
#import "FormHandler.h"
#import "FormSectionHandler.h"
#import "ElementHandler.h"
#import "SubElementHandler.h"
#import "CertificateHandler.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"
#import "LookUpHandler.h"
#import "RecordHandler.h"

@interface ECSyncManager ()
{
    NSArray *_syncOperationsList;
    NSInteger _activeOperationIndex;
}
@end

@implementation ECSyncManager

// Start syncing all the database tables with server.
- (void)startCompleteSync
{
    listTables.add(new CompanySyncOperation(context, 0));
    listTables.add(new FormSyncOperation(context, 0));
    if(isSyncAtlogin) listTables.add(new ElementSyncOperation(context, 0));
    listTables.add(new RecordSyncOperation(context, 0));
    listTables.add(new LookupSyncOperation(context, 0));
    listTables.add(new CertSyncOperation(context, 0));
    listTables.add(new DataSyncOperation(context, 0));
    listTables.add(new BinarySyncOperation(context, 0));
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormHandler        *formHandler        = [FormHandler new];
    FormSectionHandler *formSectionHandler = [FormSectionHandler new];
    ElementHandler     *elementHandler     = [ElementHandler new];
    SubElementHandler  *subElementHandler  = [SubElementHandler new];
    CertificateHandler *certHandler        = [CertificateHandler new];
    DataHandler        *dataHandler        = [DataHandler new];
    DataBinaryHandler  *dataBinaryHandler  = [DataBinaryHandler new];
    LookUpHandler      *lookupHandler      = [LookUpHandler new];
    RecordHandler      *recordHandler      = [RecordHandler new];
    
    _syncOperationsList = @[companyUserHandler];
    _activeOperationIndex = 0;
    
    NSDictionary *loginCredential = @{
                                        @"user_email": APP_DELEGATE.loggedUserEmail,
                                        @"user_password": APP_DELEGATE.loggedUserPassword
                                      };
    
    [companyUserHandler loginWithCredentials:loginCredential
                                   onSuccess:^(ECHttpResponseModel *response)
    {
        if (_syncOperationsList && _syncOperationsList.count > _activeOperationIndex)
        {
            [self startSyncWithOperation:_syncOperationsList[_activeOperationIndex]];
        }
    }
                                     onError:^(NSError *error)
    {
        if (LOGS_ON) NSLog(@"Login Failed");
    }];
}

- (void)startSyncWithOperation:(BaseHandler *)operation
{
    //1. get last sync timestamp & get records from server after that timestamp
    NSTimeInterval timestamp = [operation getSyncTimestampOfTableForCompany:APP_DELEGATE.loggedUserCompanyId];
    
    [operation getRecordsWithTimestamp:timestamp
                            retryCount:REQUEST_RETRY_COUNT
                               success:^(ECHttpResponseModel *response)
     {
         FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
         
         [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
          {
              for (NSDictionary *responseInfo in response.payloadInfo)
              {
                  NSInteger serverId = [[responseInfo objectForKey:operation.serverIdField] integerValue];
                  NSInteger appId    = [operation getAppId:serverId];
                  
                  if (appId > 0)
                  {
                      //Get all fields of table from response info
                      NSDictionary *recordInfo = [operation populateInfoForNewRecord:responseInfo];
                      
                      //see how can you find all app ids being used in the table
                      NSString *query = [operation insertQueryForInfo:recordInfo];
                      
                      if (![db executeUpdate:query withParameterDictionary:recordInfo])
                      {
                          if (LOGS_ON) NSLog(@"Insert Failed(GET - %@): %@", operation.tableName, recordInfo);
                      }
                  }
                  else
                  {
                      //Get all fields of table from record info
                      NSMutableDictionary *recordInfo = [CommonUtils getInfoWithKeys:operation.tableColumns fromDictionary:responseInfo];
                      [recordInfo setObject:@(appId) forKey:operation.appIdField];
                      
                      FMResultSet *result = [db executeQuery:@"SELECT * FROM %@ WHERE %@ = ?", operation.tableName, operation.appIdField, appId];
                      
                      if (![result next]) continue;
                      
                      NSDictionary *appRecordInfo = [result resultDictionary];
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
                              
                              NSString *query = [operation updateQueryForInfo:recordInfo];
                              
                              if (![db executeUpdate:query withParameterDictionary:recordInfo])
                              {
                                  if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", operation.tableName, recordInfo);
                              }
                          }
                      }
                      else
                      {
                          NSString *query = [operation updateQueryForInfo:recordInfo];
                          
                          if (![db executeUpdate:query withParameterDictionary:recordInfo])
                          {
                              if (LOGS_ON) NSLog(@"Update Failed(GET - %@): %@", operation.tableName, recordInfo);
                          }
                      }
                  }
              }
              
              [operation updateTableSyncTimestamp:timestamp company:APP_DELEGATE.loggedUserCompanyId];
          }];
         
         //2. get all recently created/modified records from local & send to server
         NSArray *dirtyRecords = [operation getAllDirtyRecords];
         
         if (LOGS_ON) NSLog(@"Dirty Records(%@): %@", operation.tableName, dirtyRecords);
         
         if (dirtyRecords && dirtyRecords.count > 0)
         {
             [operation putRecords:dirtyRecords
                        retryCount:REQUEST_RETRY_COUNT
                           success:^(ECHttpResponseModel *response)
              {
                  FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
                  
                  [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
                   {
                       for (NSDictionary *responseInfo in response.payloadInfo)
                       {
                           NSInteger appId = [[responseInfo objectForKey:operation.appIdField] integerValue];
                           
                           if (appId > 0)
                           {
                               NSString *query = [operation updateQueryForInfo:responseInfo];
                               
                               if (![db executeUpdate:query withParameterDictionary:responseInfo])
                               {
                                   if (LOGS_ON) NSLog(@"Update Failed(PUT - %@): %@", operation.tableName, responseInfo);
                               }
                           }
                       }
                   }];

                  _activeOperationIndex++; // Start sync for next operation
                  
                  if (_syncOperationsList && _syncOperationsList.count > _activeOperationIndex)
                  {
                      [self startSyncWithOperation:_syncOperationsList[_activeOperationIndex]];
                  }
                  else
                  {
                      return;
                  }
              }
                             error:^(NSError *error)
              {
                  if (LOGS_ON) NSLog(@"Sync Failed(PUT - %@): %@", operation.tableName, error.localizedDescription);
                  return;
              }];
         }
     }
                                 error:^(NSError *error)
     {
         if (LOGS_ON) NSLog(@"Sync Failed(GET - %@): %@", operation.tableName, error.localizedDescription);
         return;
     }];
}

@end
