//
//  FormSectionModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 01/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormSectionModel.h"

@implementation FormSectionModel

// Override init
- (id)init
{
    self = [super init];
    if(self)
    {
        self.title  = EMPTY_STRING;
        self.footer = EMPTY_STRING;
        self.header = EMPTY_STRING;
        self.label  = EMPTY_STRING;
    }
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    self.sectionId = [resultSet intForColumn:FormSectionId];
    self.formId    = [resultSet intForColumn:FormId];
    self.label     = [resultSet stringForColumn:FormSectionLabel];
    self.header    = [resultSet stringForColumn:FormSectionHeader];
    self.footer    = [resultSet stringForColumn:FormSectionFooter];
    self.title     = [resultSet stringForColumn:FormSectionTitle];
    self.archive   = [resultSet intForColumn:Archive];
    self.sequenceOrder     = [resultSet intForColumn:FormSectionSequenceOrder];
    self.modifiedTimestamp = [resultSet doubleForColumn:ModifiedTimeStamp];
}

@end
