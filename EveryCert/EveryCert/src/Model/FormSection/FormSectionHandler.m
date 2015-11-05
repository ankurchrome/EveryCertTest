//
//  FormSectionHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormSectionHandler.h"

@implementation FormSectionHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = FormSectionTable;
        self.appIdField    = FormSectionId;
        self.serverIdField = FormSectionId;
        self.apiName       = ApiFormSection;
        self.tableColumns  = @[FormSectionId, FormId, FormSectionLabel, FormSectionSequenceOrder, FormSectionHeader, FormSectionFooter, FormSectionTitle, ModifiedTimeStamp, Archive];

        self.noLocalRecord = true;
    }
    
    return self;
}

// Return a list of all the sections of specified form
- (NSArray *)getAllSectionsOfForm:(NSInteger)formIdApp
{
    FUNCTION_START;

    FMDatabaseQueue *databaseQueue     = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *formSectionModels = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@", self.tableName, FormId, (long)formIdApp, Archive, FormSectionSequenceOrder];
        
        FMResultSet *result = [db executeQuery:query];
        
        while ([result next])
        {
            FormSectionModel *formSectionModel = [[FormSectionModel alloc] initWithResultSet:result];
            
            [formSectionModels addObject:formSectionModel];
        }
    }];
    
    return formSectionModels;
}

#pragma mark - ServerSync Methods

- (NSString *)getApiCallWithFormId:(NSInteger)formId
{
    return [NSString stringWithFormat:@"%@/%ld",self.apiName, formId];
}

- (void)syncWithServer
{
    NSString *apiCall = [self getApiCallWithFormId:self.formId];
    
    [self getRecordsWithApiCall:apiCall
                     retryCount:REQUEST_RETRY_COUNT
                        success:^(ECHttpResponseModel *response)
     {
         [self saveGetRecordsForServerOnlyTable:response.payloadInfo];
         
         [self updateTableSyncTimestamp:response.metadataTimestamp company:APP_DELEGATE.loggedUserCompanyId];
         
         [self startNextSyncOperation];
     }
                          error:^(NSError *error)
     {
         [self finishSyncWithError:error];
         
         if (LOGS_ON) NSLog(@"Sync Failed(GET - %@): %@", self.tableName, error.localizedDescription);
     }];
}

@end
