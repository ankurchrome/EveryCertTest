//
//  LookUpModel.m
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookUpModel.h"

@implementation LookUpModel

//Create LookUpModel object and initialized it with specified resultset
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    [super initWithResultSet:resultSet];
    if(resultSet)
    {
        self.lookUpIdApp        = [resultSet intForColumn: LookUpIdApp];
        self.lookUpId           = [resultSet intForColumn: LookUpId];
        self.lookUpListId       = [resultSet intForColumn: LookUpListId];
        self.recordIdApp        = [resultSet intForColumn: LookUpRecordIdApp];
        self.linkedRecordIdApp  = [resultSet intForColumn: LookUpLinkedRecordIdApp];
        self.fieldNumber        = [resultSet intForColumn: LookUpFieldNumber];
        self.option             = [resultSet stringForColumn: Options];
        self.dataValue          = [resultSet stringForColumn: LookUpDataValue];
        self.sequenceOrder      = [resultSet intForColumn: LookUpSequenceOrder];
    }
}

@end
