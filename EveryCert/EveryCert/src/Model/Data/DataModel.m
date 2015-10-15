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
        self.certificateIdApp = [resultSet intForColumn:CertificateIdApp];
        self.elementId        = [resultSet intForColumn:ElementId];
        self.recordIdApp      = [resultSet intForColumn:RecordIdApp];
        self.formId           = [resultSet intForColumn:FormId];
        self.data             = [resultSet stringForColumn:DataValue];
    }
}

-(NSString *)description
{
    NSMutableDictionary *info = [NSMutableDictionary new];
    [info setValue:@(self.dataIdApp) forKey:DataIdApp];
    [info setValue:@(self.dataId) forKey:DataId];
    [info setValue:@(self.certificateIdApp) forKey:CertificateIdApp];
    [info setValue:@(self.elementId) forKey:ElementId];
    [info setValue:@(self.recordIdApp) forKey:RecordIdApp];
    [info setValue:@(self.formId) forKey:FormId];
    [info setValue:self.data forKey:DataValue];
    [info setValue:@(self.modifiedTimestampApp) forKey:ModifiedTimestampApp];
    [info setValue:@(self.isDirty) forKey:IsDirty];
    [info setValue:self.uuid forKey:Uuid];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    NSString *desc = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return desc;
}

@end
