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
    
    CompletionSync _completionSyncBlock;
}
@end

@implementation ECSyncManager

// Start syncing all the database tables with server.
- (void)startCompleteSyncWithCompletion:(CompletionSync)completion
{
    _completionSyncBlock = completion;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinished:) name:SyncFinishedNotification object:nil];
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormHandler        *formHandler        = [FormHandler new];
    ElementHandler     *elementHandler     = [ElementHandler new];
    RecordHandler      *recordHandler      = [RecordHandler new];
    LookUpHandler      *lookupHandler      = [LookUpHandler new];
    CertificateHandler *certHandler        = [CertificateHandler new];
    DataHandler        *dataHandler        = [DataHandler new];
    DataBinaryHandler  *dataBinaryHandler  = [DataBinaryHandler new];

    companyUserHandler.nextSyncHandler  = formHandler;
    formHandler.nextSyncHandler         = elementHandler;
    elementHandler.nextSyncHandler      = recordHandler;
    recordHandler.nextSyncHandler       = lookupHandler;
    lookupHandler.nextSyncHandler       = certHandler;
    certHandler.nextSyncHandler         = dataHandler;
    dataHandler.nextSyncHandler         = dataBinaryHandler;
    
    elementHandler.formId = 0;

    NSDictionary *loginCredential = @{
                                        CompanyUserFieldNameEmail: APP_DELEGATE.loggedUserEmail,
                                        CompanyUserFieldNamePassword: APP_DELEGATE.loggedUserPassword
                                      };
    
    [companyUserHandler loginWithCredentials:loginCredential
                                   onSuccess:^(ECHttpResponseModel *response)
    {
        [companyUserHandler syncWithServer];
    }
                                     onError:^(NSError *error)
    {
        if (LOGS_ON) NSLog(@"Login Failed");
        
        [self syncFinished:nil];
    }];
}

- (void)backupDataWithCompletion:(CompletionSync)completion
{
    _completionSyncBlock = completion;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinished:) name:SyncFinishedNotification object:nil];
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormHandler        *formHandler        = [FormHandler new];
    RecordHandler      *recordHandler      = [RecordHandler new];
    LookUpHandler      *lookupHandler      = [LookUpHandler new];
    CertificateHandler *certHandler        = [CertificateHandler new];
    DataHandler        *dataHandler        = [DataHandler new];
    DataBinaryHandler  *dataBinaryHandler  = [DataBinaryHandler new];
    
    companyUserHandler.nextSyncHandler  = formHandler;
    formHandler.nextSyncHandler         = recordHandler;
    recordHandler.nextSyncHandler       = lookupHandler;
    lookupHandler.nextSyncHandler       = certHandler;
    certHandler.nextSyncHandler         = dataHandler;
    dataHandler.nextSyncHandler         = dataBinaryHandler;
    
    NSDictionary *loginCredential = @{
                                      CompanyUserFieldNameEmail: APP_DELEGATE.loggedUserEmail,
                                      CompanyUserFieldNamePassword: APP_DELEGATE.loggedUserPassword
                                      };
    
    [companyUserHandler loginWithCredentials:loginCredential
                                   onSuccess:^(ECHttpResponseModel *response)
     {
         [companyUserHandler syncWithServer];
     }
                                     onError:^(NSError *error)
     {
         if (LOGS_ON) NSLog(@"Login Failed");
         
         [self syncFinished:nil];
     }];
}

- (void)downloadForm:(NSInteger)formId completion:(CompletionSync)completion;
{
    _completionSyncBlock = completion;
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    FormSectionHandler *formSectionHandler = [FormSectionHandler new];
    ElementHandler     *elementHandler     = [ElementHandler new];
    SubElementHandler  *subElementHandler  = [SubElementHandler new];
    
    formSectionHandler.formId = formId;
    elementHandler.formId     = formId;
    subElementHandler.formId  = formId;
    
    formSectionHandler.nextSyncHandler = elementHandler;
    elementHandler.nextSyncHandler = subElementHandler;
    
    NSDictionary *loginCredential = @{
                                      CompanyUserFieldNameEmail: APP_DELEGATE.loggedUserEmail,
                                      CompanyUserFieldNamePassword: APP_DELEGATE.loggedUserPassword
                                      };
    
    [companyUserHandler loginWithCredentials:loginCredential
                                   onSuccess:^(ECHttpResponseModel *response)
     {
         [formSectionHandler syncWithServer];
     }
                                     onError:^(NSError *error)
     {
         if (LOGS_ON) NSLog(@"Login Failed");
     }];
}

- (void)syncFinished:(NSNotification *)notification
{
    if (LOGS_ON) NSLog(@"Sync Finished response. Error: %@", notification);
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    
    [companyUserHandler logoutUserSuccess:^(ECHttpResponseModel *response)
    {
        if (_completionSyncBlock)
        {
            _completionSyncBlock();
        }
    }
                                  onError:^(NSError *error)
    {
        if (_completionSyncBlock)
        {
            _completionSyncBlock();
        }
    }];
}

@end
