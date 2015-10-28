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

- (NSString *)getApiCallWithTimestamp:(NSTimeInterval)timestamp
{
    return [NSString stringWithFormat:@"%@/%ld",self.apiName, self.formId];
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

@end
