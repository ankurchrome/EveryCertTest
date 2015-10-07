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

- (NSInteger)getLookupIdAppOfFieldNo:(NSInteger)fieldNumber record:(NSInteger)recordIdApp
{
    __block NSInteger lookupIdApp = 0;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ? AND %@ = ?", LookUpIdApp, self.tableName, LookUpFieldNumber, RecordIdApp];
         
         FMResultSet *result = [db executeQuery:query, @(fieldNumber), @(recordIdApp)];
         
         if ([result next])
         {
             lookupIdApp = [result intForColumn:LookUpIdApp];
         }
     }];
    
    return lookupIdApp;
}

// Insert a LookupModel object information into lookup table.
- (NSInteger)insertLookupModel:(LookUpModel *)lookupModel
{
    __block NSInteger rowId = false;
    
    lookupModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    lookupModel.isDirty = true;
    lookupModel.uuid = [[NSUUID new] UUIDString];
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         BOOL success = false;
         
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)", self.tableName, LookUpId, LookUpListId, RecordIdApp, LookUpLinkedRecordIdApp, LookUpFieldNumber, LookUpOption, LookUpDataValue, LookUpSequenceOrder, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
         
         success = [db executeUpdate:query, @(lookupModel.lookUpId), @(lookupModel.lookUpListId), @(lookupModel.recordIdApp), @(lookupModel.linkedRecordIdApp), @(lookupModel.fieldNumber), lookupModel.option, lookupModel.dataValue, @(lookupModel.sequenceOrder), @(lookupModel.modifiedTimestampApp).stringValue, @(lookupModel.modifiedTimestamp).stringValue, @(lookupModel.archive), lookupModel.uuid, @(lookupModel.isDirty), @(lookupModel.companyId)];
         
         if (success)
         {
             rowId = (NSInteger)[db lastInsertRowId];
         }
     }];
    
    return rowId;
}

- (NSArray *)getAllLookupRecordsForList:(NSInteger)lookupListId linkedRecordId:(NSInteger)linkedRecordIdApp companyId:(NSInteger)companyId
{
    FMDatabaseQueue *databaseQueue     = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *lookupRecordsList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT %@, %@, group_concat(data,', ') AS %@ FROM %@ WHERE %@ = ? AND %@ = ? AND %@ != 1 AND %@ = ? GROUP BY %@ ORDER BY %@, %@", LookUpListId, RecordIdApp, LookUpRecordTitleColumnAlias, self.tableName, LookUpListId, LookUpLinkedRecordIdApp, Archive, CompanyId, RecordIdApp, RecordIdApp, LookUpSequenceOrder];
         
         FMResultSet *result = [db executeQuery:query, @(lookupListId), @(linkedRecordIdApp), @(companyId)];
         
         while ([result next])
         {
             NSDictionary *lookupRecordInfo = [result resultDictionary];
             [lookupRecordsList addObject:lookupRecordInfo];
         }
     }];
    
    return lookupRecordsList;
}

- (NSArray *)getAllFieldsOfRecord:(NSInteger)recordIdApp lookupList:(NSInteger)lookupListId
{
    FMDatabaseQueue *databaseQueue     = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *lookupRecordsList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?", self.tableName, LookUpListId, RecordIdApp];
         
         FMResultSet *result = [db executeQuery:query, @(lookupListId), @(recordIdApp)];
         
         while ([result next])
         {
             LookUpModel *lookupModel = [[LookUpModel alloc] initWithResultSet:result];
             
             [lookupRecordsList addObject:lookupModel];
         }
     }];
    
    return lookupRecordsList;
}

@end
