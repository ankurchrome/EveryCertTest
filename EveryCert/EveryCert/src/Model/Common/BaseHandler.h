//
//  BaseHandler.h
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBDataSource.h"
#import "ECHttpClient.h"
#import "ECHttpResponseModel.h"

typedef void(^SuccessCallback)(ECHttpResponseModel *response);
typedef void(^SuccessCallbackWithObjects)(NSArray *objects);
typedef void(^ErrorCallback)(NSError *error);
typedef void(^ProgressBlock)(float progress);

@interface BaseHandler : NSObject

@property(nonatomic, strong) NSString *tableName;
@property(nonatomic, strong) NSString *appIdField;
@property(nonatomic, strong) NSString *serverIdField;
@property(nonatomic, strong) NSString *apiName;
@property(nonatomic, strong) NSArray  *commonTableColumns;
@property(nonatomic, strong) NSArray  *tableColumns;
@property(nonatomic, assign) BOOL noLocalRecord;


- (NSString *)insertQueryForInfo:(NSDictionary *)recordInfo;

- (NSString *)updateQueryForInfo:(NSDictionary *)recordInfo;

/**
 Insert into table with columns and their data defined in the columnInfo and return the app id generated locally
 @param  columnInfo A NSDictionary object which contains column names with their data to insert
 @return NSInteger returns a last row id inserted by database if record inserted successfully otherwise returns 0
 */
- (NSInteger)insertInfo:(NSDictionary *)columnInfo;

/**
 Update into table with columns and their data defined in the columnInfo for the given recordIdApp
 @param  columnInfo A NSDictionary object which contains column names with their data to update
 @param  recordIdApp Local id of a record to be update in table
 @return BOOL returns true if record updated successfully otherwise false
 */
- (BOOL)updateInfo:(NSDictionary *)columnInfo recordIdApp:(NSInteger)recordIdApp;

// Returns local Record id for given server Id.
- (NSInteger)getAppId:(NSInteger)serverId;

// Returns server id for given app Id.
- (NSInteger)getServerId:(NSInteger)appId;

// Get the last updated sync timestamp for the table.
- (NSTimeInterval)getSyncTimestampOfTableForCompany:(NSInteger)companyId;

// Update the sync timestamp for the table after update all GET records.
- (BOOL)updateTableSyncTimestamp:(NSTimeInterval)timestamp company:(NSInteger)companyId;

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info;

// Return the list of all Created/Modified customers through app, the sync process send them to server.
- (NSArray *)getAllDirtyRecords;

- (void)saveGetRecords:(NSArray *)records;
- (void)savePutRecords:(NSArray *)records;

#pragma mark - NetworkService Methods

- (void)getRecordsWithTimestamp:(NSTimeInterval)timestamp retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse;

- (void)putRecords:(NSArray *)records retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse;

@end