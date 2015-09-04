//
//  BaseModel.m
//  Volunteer
//
//  Created by Ankur Pachauri on 13/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _uuid = EMPTY_STRING;
    }
    
    return self;
}

// This Method is used to Initialize a Model object with the specified Result Set
- (id)initWithResultSet: (FMResultSet *)resultSet
{
    self = [super init];
    
    if (self)
    {
        [self setFromResultSet:resultSet];
    }
    
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    self.archive = [resultSet intForColumn:Archive];
    self.uuid = [resultSet stringForColumn:Uuid];
    self.isDirty = [resultSet intForColumn:IsDirty];
    self.companyId = [resultSet intForColumn:CompanyId];
    self.modifiedTimestampApp = [resultSet doubleForColumn:ModifiedTimestampApp];
    self.modifiedTimestamp = [resultSet doubleForColumn:ModifiedTimeStamp];
}

@end
