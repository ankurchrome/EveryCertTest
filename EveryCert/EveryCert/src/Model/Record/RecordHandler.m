//
//  RecordHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RecordHandler.h"

@implementation RecordHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = RecordTable;
        self.appIdField    = RecordIdApp;
        self.serverIdField = RecordId;
        self.tableColumns  = @[RecordIdApp, RecordId, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a new company's record into 'record' table and returns row id for inserted row
- (NSInteger)insertRecordForCompanyId:(NSInteger)companyId
{
    __block NSInteger rowId = 0;
    
    RecordModel *record = [RecordModel new];
    
    record.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    record.isDirty = true;
    record.uuid = [[NSUUID new] UUIDString];
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         BOOL success = false;
         
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@) VALUES (?,?,?,?)", self.tableName, ModifiedTimestampApp, Uuid, IsDirty, CompanyId];
         
         success = [db executeUpdate:query, @(record.modifiedTimestampApp).stringValue, record.uuid, @(record.isDirty), @(companyId)];
         
         if (success)
         {
             rowId = (NSInteger)[db lastInsertRowId];
         }
     }];
    
    return rowId;
}

@end