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
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'", self.tableName, CompanyUserFieldName, element.fieldName, CompanyUserData, element.dataValue];

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
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *query = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@ = %ld", CompanyId, CompanyUserFieldName, CompanyUserData, self.tableName, UserId, (long)userId];
        
        FMResultSet *resultSet = [db executeQuery:query];
        
        while ([resultSet next])
        {
            NSInteger companyId = [resultSet intForColumn:CompanyId];
            NSString *fieldName = [resultSet stringForColumn:CompanyUserFieldName];
            NSString *fieldData = [resultSet stringForColumn:CompanyUserData];
            
            APP_DELEGATE.loggedUserId = userId;
            APP_DELEGATE.loggedUserCompanyId = companyId;
            
            [userDefault setInteger:userId    forKey:UserId];
            [userDefault setInteger:companyId forKey:CompanyId];
            
            if (![CommonUtils isValidString:fieldData]) continue;
                
            if ([fieldName isEqualToString:CompanyUserFieldNameEmail])
            {
                APP_DELEGATE.loggedUserEmail = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserEmail];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNamePassword])
            {
                APP_DELEGATE.loggedUserPassword = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserPassword];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNameFullName])
            {
                APP_DELEGATE.loggedUserFullName = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserFullName];
            }
            else if ([fieldName isEqualToString:CompanyUserFieldNamePermissionGroup])
            {
                APP_DELEGATE.loggedUserPermissionGroup = fieldData;
                
                [userDefault setObject:fieldData forKey:LoggedUserPermissionGroup];
            }
        }
        
        [userDefault synchronize];
    }];
}

@end
