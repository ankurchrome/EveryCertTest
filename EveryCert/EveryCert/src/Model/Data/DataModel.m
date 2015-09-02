//
//  DataModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

// This Method is used to Set all Model's Properties with the Result Set
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    [super initWithResultSet:resultSet];
    if (resultSet)
    {
        self.dataIdApp        = [resultSet intForColumn:DataIdApp];
        self.certificateIdApp = [resultSet intForColumn:CertificateIdApp];
        self.elementId        = [resultSet intForColumn:ElementId];
        self.data             = [resultSet stringForColumn:DataValue];
    }
}

@end
