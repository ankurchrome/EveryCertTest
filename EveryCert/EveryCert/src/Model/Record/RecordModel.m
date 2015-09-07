//
//  RecordModel.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    if (resultSet)
    {
        self.recordIdApp = [resultSet intForColumn:LookUpIdApp];
        self.recordId    = [resultSet intForColumn:LookUpId];
    }
}

@end