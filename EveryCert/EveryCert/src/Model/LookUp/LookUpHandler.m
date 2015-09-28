//
//  LookUpHandler.m
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookUpHandler.h"

@implementation LookUpHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = LookUpTable;
        self.appIdField    = LookUpIdApp;
        self.serverIdField = LookUpId;
        self.tableColumns  = @[LookUpIdApp, LookUpId, LookUpListId, RecordIdApp, LookUpLinkedRecordIdApp, LookUpFieldNumber, LookUpOption, LookUpDataValue, LookUpSequenceOrder, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

- (NSArray *)getAllLookupRecordsForList:(NSInteger)lookupListId linkedRecordId:(NSInteger)linkedRecordIdApp
{
    FMDatabaseQueue *databaseQueue     = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *lookupRecordsList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT FROM %@ WHERE %@ = ? AND %@ = ? ORDER BY %@, %@", self.tableName, LookUpListId, LookUpLinkedRecordIdApp, RecordIdApp, LookUpSequenceOrder];
         
         FMResultSet *result = [db executeQuery:query, @(lookupListId), @(linkedRecordIdApp)];
         
         while ([result next])
         {
             if (LOGS_ON) NSLog(@"Result Info: %@", [result resultDictionary]);
             
             LookUpModel *lookupModel = [[LookUpModel alloc] initWithResultSet:result];
             
             [lookupRecordsList addObject:lookupModel];
         }
     }];
    
    return lookupRecordsList;
}

@end
