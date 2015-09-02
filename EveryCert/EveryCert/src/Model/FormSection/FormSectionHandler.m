//
//  FormSectionHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormSectionHandler.h"

@implementation FormSectionHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = FormSectionTable;
        self.serverIdField = FormSectionId;
        self.tableColumns  = @[FormSectionId, FormId, FormSectionLabel, FormSectionSequenceOrder, FormSectionHeader, FormSectionFooter, FormSectionTitle, ModifiedTimeStamp, Archive];
    }
    
    return self;
}

// Return a list of all the sections of specified form
- (NSArray *)getAllSectionsOfForm:(NSInteger)formIdApp
{
    FUNCTION_START;

    NSMutableArray   *formSectionModels = nil;
    NSString         *query = nil;
    FormSectionModel *formSectionModel = nil;
    FMResultSet      *result = nil;
    
    query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@", self.tableName, FormId, (long)formIdApp, Archive, FormSectionSequenceOrder];
    
    result = [self.database executeQuery:query];

    formSectionModels = [NSMutableArray new];
    
    while ([result next])
    {
        formSectionModel = [[FormSectionModel alloc] initWithResultSet:result];

        [formSectionModels addObject:formSectionModel];
    }
    
    FUNCTION_END;
    
    return formSectionModels;
}

@end
