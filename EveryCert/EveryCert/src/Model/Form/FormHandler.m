//
//  FormHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormHandler.h"

@implementation FormHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = FormTable;
        self.appIdField    = FormId;
        self.serverIdField = FormId;
        self.apiName       = ApiForm;
        self.tableColumns  = @[FormId, FormCategoryId, FormName, FormTitle, FormBackgroundLayout, FormStatus, FormCompanyFormat, FormSequenceOrder, FormPermissionGroup, ModifiedTimestampApp, ModifiedTimeStamp, Archive];
        
        self.noLocalRecord = true;
    }
    
    return self;
}

//Returns a list of all forms with given permissions from the database
- (NSArray *)getAllFormsWithPermissions:(NSString *)permissions
{
    FUNCTION_START;
    
    //Create permission condition query
    NSArray         *permissionList = nil;
    NSMutableArray  *permissionCondList = nil;
    NSMutableString *permissionCondQuery = nil;
    
    permissionCondQuery = [[NSMutableString alloc] initWithString:EMPTY_STRING];
    
    if ([CommonUtils isValidString:permissions])
    {
        permissionList     = [permissions componentsSeparatedByString:@","];
        permissionCondList = [NSMutableArray new];
        
        for (NSString *permission in permissionList)
        {
            NSString *trimmedString = [permission stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *condition = [NSString stringWithFormat:@"%@ = %@", FormPermissionGroup, trimmedString];
            [permissionCondList addObject:condition];
        }
        
        if (permissionCondList.count > 0)
        {
            NSString *condQueryString = [permissionCondList componentsJoinedByString:@" OR "];
            [permissionCondQuery appendFormat:@" AND (%@)", condQueryString];
        }
    }

    //Get all forms with permissions(if any)
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *allForms      = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ != 1 %@ ORDER BY %@, %@", self.tableName, Archive, permissionCondQuery, FormCategoryId, FormSequenceOrder];

        FMResultSet *result = [db executeQuery:query];

        while ([result next])
        {
            FormModel *formModel = [[FormModel alloc] initWithResultSet:result];
            
            [allForms addObject:formModel];
        }
    }];

    return allForms;
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

- (NSMutableDictionary *)populateInfoForServerOnlyExistingRecord:(NSDictionary *)info db:(FMDatabase *)db
{
    NSMutableDictionary *recordInfo = [super populateInfoForServerOnlyExistingRecord:info db:db];
    
    [recordInfo setObject:@(false) forKey:FormStatus];
    
    return recordInfo;
}

@end
