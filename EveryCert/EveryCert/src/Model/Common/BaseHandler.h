//
//  BaseHandler.h
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBDataSource.h"

@interface BaseHandler : NSObject

@property(nonatomic, strong) NSString *tableName;
@property(nonatomic, strong) NSString *appIdField;
@property(nonatomic, strong) NSString *serverIdField;
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
 Update the table with columns and their data defined in the columnInfo for the given recordIdApp
 @param  columnInfo A NSDictionary object which contains column names with their data to update
 @param  recordIdApp Local id of a record to be update in table
 @return BOOL returns true if record updated successfully otherwise false
 */
- (BOOL)updateInfo:(NSDictionary *)columnInfo recordIdApp:(NSInteger)recordIdApp;

@end