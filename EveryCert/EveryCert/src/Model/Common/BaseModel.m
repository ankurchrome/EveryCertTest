//
//  BaseModel.m
//  Volunteer
//
//  Created by Ankur Pachauri on 13/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

// This Method is used to Initialize Model with the Result Set
- (void)initWithResultSet: (FMResultSet *)resultSet
{
    [self setFromResultSet:resultSet];
}

// This Method is used to Set all Model's Properties with the Result Set
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    self.modifiedTimestampApp = [resultSet doubleForColumn:ModifiedTimestampApp];
    self.modifiedTimestamp = [resultSet doubleForColumn:ModifiedTimeStamp];
    self.archive = [resultSet intForColumn:Archive];
    self.uuid = [resultSet stringForColumn:UUid];
    self.isDirty = [resultSet intForColumn:IsDirty];
    self.companyId = [resultSet intForColumn:CompanyId];
}

@end
