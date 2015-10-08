//
//  BaseHandler.m
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler

// Initialized the BaseHandler object with the FMDatabase object and linked it to sqlite database stored in Document dir.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.commonTableColumns = [[NSArray alloc] initWithObjects:ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid, nil];
    }
    
    return self;
}

//this function will create dynamic query from update information for a given table may have condition string
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo havingConditionStatement: (NSString *)conditionString
{
    FUNCTION_START;
    
    NSString *query = [self updateQueryForTable:tableName withColumnInfo:columnInfo];
    
    if (![CommonUtils isValidString:query]) return nil;
    
    NSMutableString *queryWithCondition = [NSMutableString stringWithString:query];
    
    if ([CommonUtils isValidString:conditionString])
    {
        [queryWithCondition appendFormat:@" %@ ", conditionString];
    }
    
    FUNCTION_END;
    return queryWithCondition;
}

//this function will create dynamic query from update information for a given table.
- (NSString *)updateQueryForTable:(NSString *)tableName withColumnInfo:(NSDictionary *)columnInfo
{
    FUNCTION_START;

    NSMutableString *columnsListString = nil;
    NSArray  *columnsArray = nil;
    NSString *query        = nil;
    NSString *column       = nil;
    
    if (!columnInfo) return nil;
    
    columnsArray = [columnInfo allKeys];
    
    if (columnsArray && columnsArray.count > 0)
    {
        column = [columnsArray objectAtIndex:0];
        NSString *value = [columnInfo objectForKey:column];
        
        if ([value respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
        {
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            columnsListString = [NSMutableString stringWithFormat:@"'%@'='%@'", column, value];
        }
        
        for (int i = 1; i < [columnsArray count]; i ++)
        {
            column = [columnsArray objectAtIndex:i];
            value  = [columnInfo objectForKey:column];
            
            if ([value respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                [columnsListString appendFormat:@", '%@'='%@'", column, value];
            }
        }
    }
    
    query = [NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, columnsListString];
    
    return query;
    FUNCTION_END;
}

// Update the table with columns and their data defined in the columnInfo for the given recordIdApp
- (BOOL)updateInfo:(NSDictionary *)columnInfo recordIdApp:(NSInteger)recordIdApp
{
    __block BOOL success = false;
    
    if (!columnInfo || columnInfo.count <= 0 || recordIdApp <=0) return success;
        
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSMutableDictionary *updatedColumnInfo = [[NSMutableDictionary alloc] initWithDictionary:columnInfo];

         //Make column string to bind the column data from dictionary
         NSMutableString *columnString = [NSMutableString new];
         for (NSString *key in [updatedColumnInfo allKeys])
         {
             [columnString appendFormat:@"%@ = :%@, ", key, key];
         }
         [columnString deleteCharactersInRange:NSMakeRange(columnString.length-2, 2)];
         
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = :%@", self.tableName, columnString, self.appIdField, self.appIdField];

         [updatedColumnInfo setObject:@(recordIdApp) forKey:self.appIdField];
         success = [db executeUpdate:query withParameterDictionary:updatedColumnInfo];
     }];
    
    return success;
}

@end