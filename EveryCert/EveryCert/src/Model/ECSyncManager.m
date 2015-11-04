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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    hud.labelText = HudTitleLoading;
    
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
     }
                                     onError:^(NSError *error)
     {
         if (LOGS_ON) NSLog(@"Login Failed");
     }];
}

- (void)syncFinished:(id)object
{
    if (LOGS_ON) NSLog(@"Sync Finished response. Error: %@", object);
    
    [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    
    [companyUserHandler logoutUserSuccess:^(ECHttpResponseModel *response)
    {
        [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
    }
                                  onError:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
    }];
    
    if (!object)
    {
        DataBinaryHandler *dataBinaryHandler = [DataBinaryHandler new];
        
        [dataBinaryHandler downloadAllDataBinary];
    }
}

@end
