//
//  LookUpHandler.m
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookUpHandler.h"
#import "RecordHandler.h"

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
        self.apiName       = ApiLookup;
        self.tableColumns  = @[LookUpIdApp, LookUpId, LookUpListId, RecordIdApp, LookUpLinkedRecordIdApp, LookUpFieldNumber, LookUpOption, LookUpDataValue, LookUpSequenceOrder, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Get the app id of given field of lookup record
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
    __block NSInteger rowId = 0;
    
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

// Fetch all the lookup records of given type(Customer, Job addresses, appliances etc.) which are linked to given record if any.
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

// Fetch all the fields of a given record
- (NSArray *)getAllFieldsOfRecord:(NSInteger)recordIdApp
{
    FMDatabaseQueue *databaseQueue     = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *lookupRecordsList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", self.tableName, RecordIdApp];
         
         FMResultSet *result = [db executeQuery:query, @(recordIdApp)];
         
         while ([result next])
         {
             LookUpModel *lookupModel = [[LookUpModel alloc] initWithResultSet:result];
             
             [lookupRecordsList addObject:lookupModel];
         }
     }];
    
    return lookupRecordsList;
}

#pragma mark - ServerSync Methods

- (NSTimeInterval)getSyncTimestampOfTableForCompany:(NSInteger)companyId
{
    NSTimeInterval timestamp = [super getSyncTimestampOfTableForCompany:companyId];
    
    if (timestamp <= 0.0)
    {
        timestamp = INITIAL_TIMESTAMP_LOOKUP;
    }
    
    return timestamp;
}

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info
{
    NSInteger recordId = [info[RecordId] integerValue];
    NSInteger linkedRecordId = [info[LookUpLinkedRecordId] integerValue];
    
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    RecordHandler *recordHandler = [RecordHandler new];
    
    NSInteger recordIdApp = recordId > 0 ? [recordHandler getAppId:recordId] : 0;
    
    if (recordIdApp <= 0)
    {
        if (LOGS_ON) NSLog(@"Record not found: %ld", recordId); return nil;
    }

    [newRecordInfo setObject:@(recordIdApp).stringValue forKey:RecordIdApp];
    
    NSInteger linkedRecordIdApp = linkedRecordId > 0 ? [recordHandler getAppId:linkedRecordId] : 0;
    
    [newRecordInfo setObject:@(linkedRecordIdApp).stringValue forKey:LookUpLinkedRecordIdApp];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimestampApp];
    }
    
    return newRecordInfo;
}

@end
