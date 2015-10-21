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

@implementation ECSyncManager

// Start syncing all the database tables with server.
- (void)startCompleteSync
{
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
    
    NSArray *syncOperationsList = @[companyUserHandler];
    
    NSDictionary *loginCredential = @{
                                        @"user_email": APP_DELEGATE.loggedUserEmail,
                                        @"user_password": APP_DELEGATE.loggedUserPassword
                                      };
    
    [companyUserHandler loginWithCredentials:loginCredential
                                   onSuccess:^(ECHttpResponseModel *response)
    {
        for (BaseHandler *handler in syncOperationsList)
        {
            [handler syncWithServer];
        }
    }
                                     onError:^(NSError *error)
    {
        if (LOGS_ON) NSLog(@"Login Failed");
    }];
}

@end
