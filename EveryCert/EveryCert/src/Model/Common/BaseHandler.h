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

/**
 This method will create query dynamically through the table name and given columns with their values and append the condition string if any
 @param  tableName Table name string for which query is being made
 @param  columnInfo A NSDictionary object which contains column names with their data to update
 @param  conditionString A condtion string which will be append in query with WHERE clause
 @return NSString Returns a query string if it is made successfully otherwise nil
 */
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo havingConditionStatement: (NSString *)conditionString;

/**
 This method will create query dynamically through the table name and given columns with their values
 @param  tableName Table name string for which query is being made
 @param  columnInfo A NSDictionary object which contains column names with their data to update
 @return NSString Returns a query string if it is made successfully otherwise nil
 */
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo;

/**
 Update into table with columns and their data defined in the columnInfo for the given recordIdApp
 @param  columnInfo A NSDictionary object which contains column names with their data to update
 @param  recordIdApp Local id of a record to be update in table
 @return BOOL returns true if record updated successfully otherwise false
 */
- (BOOL)updateInfo:(NSDictionary *)columnInfo recordIdApp:(NSInteger)recordIdApp;

// Insert into table with columns and their data defined in the columnInfo and return the app id generated locally
/**
 Insert into table with columns and their data defined in the columnInfo and return the app id generated locally
 @param  columnInfo A NSDictionary object which contains column names with their data to insert
 @return NSInteger returns a last row id inserted by database if record inserted successfully otherwise returns 0
 */
- (NSInteger)insertInfo:(NSDictionary *)columnInfo;

- (void)syncWithServer;

@end