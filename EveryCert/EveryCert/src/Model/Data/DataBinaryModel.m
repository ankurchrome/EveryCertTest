//
//  DataBinaryModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataBinaryModel.h"

@implementation DataBinaryModel

// This Method is used to Set all Model's Properties with the Result Set
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    if (resultSet)
    {
        self.dataIdApp        = [resultSet intForColumn:DataBinaryIdApp];
        self.dataId           = [resultSet intForColumn:DataId];
        self.certificateIdApp = [resultSet intForColumn:CertificateIdApp];
        self.elementId        = [resultSet intForColumn:ElementId];
        self.recordIdApp      = [resultSet intForColumn:RecordIdApp];
        self.data             = [resultSet dataForColumn:DataValue];
    }
}

@end
