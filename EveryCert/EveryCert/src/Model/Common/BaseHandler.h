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
#import "AFHTTPRequestOperation.h"

typedef void(^SuccessCallback)(ECHttpResponseModel *response);
typedef void(^DownloadImageCallback)(UIImage *image, NSError *error);
typedef void(^ErrorCallback)(NSError *error);

@interface BaseHandler : NSObject

@property(nonatomic, strong) NSString *tableName;
@property(nonatomic, strong) NSString *appIdField;
@property(nonatomic, strong) NSString *serverIdField;
@property(nonatomic, strong) NSString *apiName;
@property(nonatomic, strong) NSArray  *commonTableColumns;
@property(nonatomic, strong) NSArray  *tableColumns;
@property(nonatomic, assign) BOOL noLocalRecord;

@property(nonatomic, strong) FMDatabase *db;

@property(nonatomic, strong) BaseHandler *nextSyncHandler;

#pragma mark - Common Methods

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

// Returns record info from active table for given app id
- (NSDictionary *)getRecordInfoWithAppId:(NSInteger)appId;

#pragma mark - ServerSync Methods

#pragma mark Info
- (NSTimeInterval)getSyncTimestampOfTableForCompany:(NSInteger)companyId;
- (BOOL)updateTableSyncTimestamp:(NSTimeInterval)timestamp company:(NSInteger)companyId;
- (NSString *)getApiCallWithTimestamp:(NSTimeInterval)timestamp;
- (NSArray *)getAllDirtyRecords;

#pragma mark Sync
- (void)syncWithServer;

#pragma mark Response
- (void)saveGetRecords:(NSArray *)records;
- (void)saveGetRecordsForServerOnlyTable:(NSArray *)records;
- (void)savePutRecords:(NSArray *)records;
- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info;
- (NSMutableDictionary *)populateInfoForExistingRecord:(NSDictionary *)info appId:(NSInteger)appId;
- (void)startNextSyncOperation;
- (void)finishSyncWithError:(NSError *)error;

#pragma mark - NetworkService Methods

- (void)getRecordsWithApiCall:(NSString *)apiCall retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse;

- (void)getRecordsWithTimestamp:(NSTimeInterval)timestamp retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse;

- (void)putRecords:(NSArray *)records retryCount:(NSInteger)retryCount success:(SuccessCallback)successResponse error:(ErrorCallback)errorResponse;

- (void)downloadFileWithUrl:(NSString *)urlString destinationUrl:(NSURL *)destinationUrl retryCount:(NSInteger)retryCount completion:(ErrorCallback)completion;

@end

extern NSString *const SyncFinishedNotification;

