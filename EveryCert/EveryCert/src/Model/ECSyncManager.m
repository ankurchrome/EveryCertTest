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
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormHandler        *formHandler        = [FormHandler new];
    ElementHandler     *elementHandler     = [ElementHandler new];
    RecordHandler      *recordHandler      = [RecordHandler new];
    LookUpHandler      *lookupHandler      = [LookUpHandler new];
    CertificateHandler *certHandler        = [CertificateHandler new];
    DataHandler        *dataHandler        = [DataHandler new];
    DataBinaryHandler  *dataBinaryHandler  = [DataBinaryHandler new];

    _activeOperationIndex = 0;
    elementHandler.formId = 0;

    _syncOperationsList = @[companyUserHandler, formHandler, elementHandler, recordHandler, lookupHandler, certHandler, dataHandler, dataBinaryHandler];
    
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

- (void)downloadForm:(NSInteger)formId
{
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormSectionHandler *formSectionHandler = [FormSectionHandler new];
    ElementHandler     *elementHandler     = [ElementHandler new];
    SubElementHandler  *subElementHandler  = [SubElementHandler new];
    
    _activeOperationIndex     = 0;
    formSectionHandler.formId = formId;
    elementHandler.formId     = formId;
    subElementHandler.formId  = formId;
    
    _syncOperationsList = @[formSectionHandler, elementHandler, subElementHandler];
    
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
         [operation saveGetRecords:response.payloadInfo];
         
         [operation updateTableSyncTimestamp:timestamp company:APP_DELEGATE.loggedUserCompanyId];

         if (operation.noLocalRecord)
         {
             [self startNextSyncOperation];
             
             return;
         }
         
         //2. get all recently created/modified records from local and send them to server
         NSArray *dirtyRecords = [operation getAllDirtyRecords];
         
         if (LOGS_ON) NSLog(@"Dirty Records(%@): %@", operation.tableName, dirtyRecords);
         
         if (dirtyRecords && dirtyRecords.count > 0)
         {
             [operation putRecords:dirtyRecords
                        retryCount:REQUEST_RETRY_COUNT
                           success:^(ECHttpResponseModel *response)
              {
                  [operation savePutRecords:response.payloadInfo];
                  
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

- (void)startNextSyncOperation
{
    _activeOperationIndex++; // Start sync for next operation
    
    if (_syncOperationsList && _syncOperationsList.count > _activeOperationIndex)
    {
        [self startSyncWithOperation:_syncOperationsList[_activeOperationIndex]];
    }
    else
    {
        CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
        
        [companyUserHandler logoutUserSuccess:^(ECHttpResponseModel *response)
        {
            if (LOGS_ON) NSLog(@"Logout Success");
        }
                                      onError:^(NSError *error)
        {
            if (LOGS_ON) NSLog(@"Logout failed");
        }];
    }
}

@end
