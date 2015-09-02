//
//  DataBinaryModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataBinaryModel.h"

@implementation DataBinaryModel

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    if (resultSet)
    {
        self.dataBinaryIdApp  = [resultSet intForColumn:DataBinaryIdApp];
        self.dataBinaryId     = [resultSet intForColumn:DataBinaryId];
        self.certificateIdApp = [resultSet intForColumn:CertificateId];
        self.elementId        = [resultSet intForColumn:ElementId];
        self.dataBinary       = [resultSet dataForColumn:DataBinaryValue];
    }
}

@end
