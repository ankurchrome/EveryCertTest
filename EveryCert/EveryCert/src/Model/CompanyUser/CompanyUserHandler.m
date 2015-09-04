//
//  CompanyUserHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CompanyUserHandler.h"
#import "ElementModel.h"

@implementation CompanyUserHandler

NSString *const CompanyUserFieldNameUserEmail           = @"user_email";
NSString *const CompanyUserFieldNameUserPassword        = @"user_password";
NSString *const CompanyUserFieldNameUserFullName        = @"user_full_name";
NSString *const CompanyUserFieldNameUserPermissionGroup = @"permission_group";

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];

    if (self)
    {
        self.tableName     = CompanyUserTable;
        self.appIdField    = CompanyUserIdApp;
        self.serverIdField = CompanyUserId;
        self.tableColumns  = @[CompanyUserIdApp, CompanyUserId, CompanyId, UserId, CompanyUserFieldName, CompanyUserData, ModifiedTimestampApp, ModifiedTimeStamp, Archive, IsDirty, Uuid];
    }
    
    return self;
}

// Check login at the app with given elements
- (BOOL)checkLoginWithElements:(NSArray *)elements
{
    __block BOOL success = true;
    __block NSInteger userId = 0;
    
    for (ElementModel *element in elements)
    {
        FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
        
        [databaseQueue inDatabase:^(FMDatabase *db)
        {
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ AND %@ = %@", self.tableName, CompanyUserFieldName, element.fieldName, CompanyUserData, element.dataValue];

            FMResultSet *result = [db executeQuery:query];
            
            if ([result next])
            {
                userId = [result intForColumn:UserId];
            }
            else
            {
                success = false;
            }
        }];
        
        if (!success) break;
    }
    
    if (success && userId > 0)
    {
        [self saveLoggedUser:userId];
    }
    
    return success;
}

//Fetch logged user data from database and store it so it can be use throughout the app
- (void)saveLoggedUser:(NSInteger)userId
{
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@ = %ld", CompanyId, CompanyUserFieldName, CompanyUserData, self.tableName, UserId, (long)userId];
        
        FMResultSet *resultSet = [db executeQuery:query];
        
        while ([resultSet next])
        {
            NSInteger companyId = [resultSet intForColumn:CompanyId];
            NSString *fieldName = [resultSet stringForColumn:CompanyUserFieldName];
            NSString *fieldData = [resultSet stringForColumn:CompanyUserData];
            
            APP_DELEGATE.loggedUserId = userId;
            APP_DELEGATE.loggedUserCompanyId = companyId;
            
            if ([fieldName isEqualToString:CompanyUserFieldNameUserEmail])
            {
                APP_DELEGATE.loggedUserEmail = fieldData;
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNameUserPassword])
            {
                APP_DELEGATE.loggedUserPassword = fieldData;
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNameUserFullName])
            {
                APP_DELEGATE.loggedUserFullName = fieldData;
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNameUserPermissionGroup])
            {
                APP_DELEGATE.loggedUserPermissionGroup = fieldData;
            }
        }
    }];
}

@end
