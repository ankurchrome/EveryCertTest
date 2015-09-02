//
//  FormModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormModel.h"

@implementation FormModel

// Create FormModel object and initialized it with specified resultset
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    NSString *attributes         = nil;
    NSData   *attributesData     = nil;
    NSDictionary *attributesInfo = nil;
    
    if (resultSet)
    {
        self.formId                = [resultSet intForColumn:FormId];
        self.categoryId            = [resultSet intForColumn:FormCategoryId];
        self.name                  = [resultSet stringForColumn:FormName];
        self.title                 = [resultSet stringForColumn:FormTitle];
        self.backgroundLayout      = [resultSet stringForColumn:FormBackgroundLayout];
        self.modifiedTimestampApp  = [resultSet doubleForColumn:ModifiedTimestampApp];
        self.modifiedTimestamp     = [resultSet doubleForColumn:ModifiedTimeStamp];
        self.archive               = [resultSet intForColumn:Archive];
        self.status                = [resultSet intForColumn:FormStatus];
        self.companyFormat         = [resultSet stringForColumn:FormCompanyFormat];
        self.formSequenceOrder     = [resultSet stringForColumn:FormSequenceOrder];
        
        attributes     = [resultSet stringForColumn:FormCompanyFormat];
        attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
        
        if (attributesData)
        {
            attributesInfo = [NSJSONSerialization JSONObjectWithData:attributesData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        }
        
        self.companyAttributes = attributesInfo;
    }
}

@end
