//
//  CompanyUserHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CompanyUserHandler.h"

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

@end
