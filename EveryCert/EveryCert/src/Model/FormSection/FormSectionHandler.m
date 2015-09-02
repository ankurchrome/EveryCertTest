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
        self.tableName  = FormSectionTable;
        self.appIdField = FormSectionId;
        self.fieldList  = [[NSArray alloc] initWithObjects:FormSectionId, FormIdApp, FormSectionName, FormSectionSequenceOrder, FormSectionHeader, FormSectionFooter, FormSectionTitle, nil];
    }    
    return self;
}

// Return a list of all the sections of specified form
- (NSArray *)allSectionsOfForm:(NSInteger)formIdApp
{
    FUNCTION_START;

    FormSectionModel *formSectionModel = nil;
    NSMutableArray *formSectionModels = [NSMutableArray new];
    
//    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld", self.tableName, FormId, (long)formIdApp];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld", self.tableName, FormId, formIdApp];

    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formSectionModel = [self formSectionModelsFromResultSet:result];
        
        [formSectionModels addObject:formSectionModel];
    }
    
    [_database close];
    
    FUNCTION_END;
    
    return formSectionModels;
}

// Create FormModel object and initialized it with specified resultset
- (FormSectionModel *)formSectionModelsFromResultSet:(FMResultSet *)resultSet
{
    FormSectionModel *formSectionModel = [FormSectionModel new];
    
    if (resultSet)
    {
        formSectionModel.sectionId  = [resultSet intForColumn:FormSectionId];
        formSectionModel.formId     = [resultSet intForColumn:FormId];
        formSectionModel.label      = [resultSet stringForColumn:FormSectionName];
        formSectionModel.sequenceOrder = [resultSet intForColumn:FormSectionSequenceOrder];
        formSectionModel.header    = [resultSet stringForColumn:FormSectionHeader];
        formSectionModel.footer    = [resultSet stringForColumn:FormSectionFooter];
        formSectionModel.title     = [resultSet stringForColumn:FormSectionTitle];
    }
    
    return formSectionModel;
}

- (NSArray *)getAllSectionModel
{
    return [self allSectionsOfForm:1];
}

@end
