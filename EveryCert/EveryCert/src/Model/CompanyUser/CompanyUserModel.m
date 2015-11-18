//
//  CompanyUserModel.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CompanyUserModel.h"

@implementation CompanyUserModel

// Override init
- (id)init
{
    self = [super init];
    if(self)
    {
        self.fieldName = EMPTY_STRING;
        self.data      = EMPTY_STRING;
    }
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    self.companyUserIdApp = [resultSet intForColumn:CompanyUserIdApp];
    self.companyUserId    = [resultSet intForColumn:CompanyUserId];
    self.userId    = [resultSet intForColumn:UserId];
    self.fieldName = [resultSet stringForColumn:CompanyUserFieldName];
    self.data      = [resultSet stringForColumn:CompanyUserData];
}

@end
