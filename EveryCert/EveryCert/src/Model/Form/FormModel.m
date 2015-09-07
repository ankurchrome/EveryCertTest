//
//  FormModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormModel.h"

@implementation FormModel

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    NSString *attributes         = nil;
    NSData   *attributesData     = nil;
    NSDictionary *attributesInfo = nil;

    self.formId     = [resultSet intForColumn:FormId];
    self.categoryId = [resultSet intForColumn:FormCategoryId];
    self.name       = [resultSet stringForColumn:FormName];
    self.title      = [resultSet stringForColumn:FormTitle];
    self.backgroundLayout     = [resultSet stringForColumn:FormBackgroundLayout];
    self.status               = [resultSet boolForColumn:FormStatus];
    self.sequenceOrder        = [resultSet intForColumn:FormSequenceOrder];
    self.permissionGroup      = [resultSet intForColumn:FormPermissionGroup];
    self.archive              = [resultSet intForColumn:Archive];
    self.modifiedTimestampApp = [resultSet doubleForColumn:ModifiedTimestampApp];
    self.modifiedTimestamp    = [resultSet doubleForColumn:ModifiedTimeStamp];

    attributes     = [resultSet stringForColumn:FormCompanyFormat];
    attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
    
    if (attributesData)
    {
        attributesInfo = [NSJSONSerialization JSONObjectWithData:attributesData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    }
    
    self.companyFormat = attributesInfo;
}

@end
