//
//  SubElementHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 27/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SubElementHandler.h"

@implementation SubElementHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = SubElementTable;
        self.appIdField    = SubElementId;
        self.serverIdField = SubElementId;
        self.apiName       = ApiSubElement;
        self.tableColumns  = @[SubElementId, ElementId, ElementFieldType, ElementFieldName, ElementSequenceOrder, ElementLabel, ElementOriginX, ElementOriginY, ElementHeight, ElementWidth, ElementPageNumber, ElementMinCharLimit, ElementMaxCharLimit, ElementPrintedTextFormat, ElementPopUpMessage, ElementLookUpListIdNew, ElementFieldNumberNew, ElementLookUpListIdExisting, ElementFieldNumberExisting, ModifiedTimeStamp, Archive];
        
        self.noLocalRecord = true;
    }
    
    return self;
}

// Fetch all sub elements of given element
- (NSArray *)getAllSubElementsOfElement:(NSInteger)elementIdApp
{
    FMDatabaseQueue *databaseQueue       = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *subElementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld ORDER BY %@", SubElementTable, ElementId, (long)elementIdApp, ElementSequenceOrder];
         
         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             SubElementModel *subElementModel = [[SubElementModel alloc] initWithResultSet:result];
             
             [subElementModelList addObject:subElementModel];
         }
     }];
    
    return subElementModelList;
}

// Fetch all sub elements of given element and initialize all sub elements with given element info
- (NSArray *)getAllSubElementsOfElement:(NSInteger)elementIdApp withInfo:(NSString *)elementInfoText
{
    NSDictionary *subElementInfo = nil;
    NSData *subElementData = [elementInfoText dataUsingEncoding:NSUTF8StringEncoding];
    
    if (subElementData)
    {
        subElementInfo = [NSJSONSerialization JSONObjectWithData:subElementData options:NSJSONReadingMutableContainers error:nil];
    }

    FMDatabaseQueue *databaseQueue       = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *subElementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld ORDER BY %@", SubElementTable, ElementId, (long)elementIdApp, ElementSequenceOrder];
         
         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             SubElementModel *subElementModel = [[SubElementModel alloc] initWithResultSet:result];
             NSString *subElementKey   = @(subElementModel.subElementId).stringValue;
             subElementModel.dataValue = [subElementInfo valueForKey:subElementKey];
             
             [subElementModelList addObject:subElementModel];
         }
     }];
    
    return subElementModelList;
}

#pragma mark - ServerSync Methods

- (NSString *)getApiCallWithFormId:(NSInteger)formId
{
    return [NSString stringWithFormat:@"%@/%ld",self.apiName, formId];
}

- (void)syncWithServer
{
    //1. get last sync timestamp & get records from server after that timestamp
    NSTimeInterval timestamp = [self getSyncTimestampOfTableForCompany:APP_DELEGATE.loggedUserCompanyId];
    
    NSString *apiCall = [self getApiCallWithFormId:self.formId];
    
    [self getRecordsWithApiCall:apiCall
                     retryCount:REQUEST_RETRY_COUNT
                        success:^(ECHttpResponseModel *response)
     {
         [self saveGetRecordsForServerOnlyTable:response.payloadInfo];
         
         [self updateTableSyncTimestamp:timestamp company:APP_DELEGATE.loggedUserCompanyId];
         
         [self startNextSyncOperation];
     }
                          error:^(NSError *error)
     {
         [self finishSyncWithError:error];
         
         if (LOGS_ON) NSLog(@"Sync Failed(GET - %@): %@", self.tableName, error.localizedDescription);
     }];
}

@end
