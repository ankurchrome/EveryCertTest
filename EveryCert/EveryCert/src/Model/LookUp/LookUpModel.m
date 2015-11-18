//
//  LookUpModel.m
//  EveryCert
//
//  Created by Ankur Pachauri on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookUpModel.h"

@implementation LookUpModel

// Override init
- (id)init
{
    self = [super init];
    if(self)
    {
        self.dataValue = EMPTY_STRING;
        self.option    = EMPTY_STRING;
    }
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    if (resultSet)
    {
        self.lookUpIdApp       = [resultSet intForColumn:LookUpIdApp];
        self.lookUpId          = [resultSet intForColumn:LookUpId];
        self.lookUpListId      = [resultSet intForColumn:LookUpListId];
        self.recordIdApp       = [resultSet intForColumn:RecordIdApp];
        self.linkedRecordIdApp = [resultSet intForColumn:LookUpLinkedRecordIdApp];
        self.fieldNumber       = [resultSet intForColumn:LookUpFieldNumber];
        self.option            = [resultSet stringForColumn:LookUpOption];
        self.dataValue         = [resultSet stringForColumn:LookUpDataValue];
        self.sequenceOrder     = [resultSet intForColumn:LookUpSequenceOrder];
    }
}

@end
