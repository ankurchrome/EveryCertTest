//
//  DataModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    if (resultSet)
    {
        self.dataIdApp        = [resultSet intForColumn:DataIdApp];
        self.dataId           = [resultSet intForColumn:DataId];
        self.certificateIdApp = [resultSet intForColumn:CertificateId];
        self.elementId        = [resultSet intForColumn:ElementId];
        self.recordIdApp      = [resultSet intForColumn:RecordIdApp];
        self.formId           = [resultSet intForColumn:FormId];
        self.data             = [resultSet stringForColumn:DataValue];
    }
}

@end
