//
//  FormHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FormHandler.h"

@implementation FormHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];

    if (self)
    {
        self.tableName  = FormTable;
        self.appIdField = FormIdApp;
        self.fieldList  = [[NSArray alloc] initWithObjects:FormId, FormCategoryId, FormName, FormTitle, FormBackgroundLayout,ModifiedTimestampApp, ModifiedTimeStamp, Archive, FormStatus, FormCompanyFormat, FormSequenceOrder, nil];
    }

    return self;
}

//Fetch the form information from database for a specified form name
- (FormModel *)formByName:(NSString *)formName
{
    FUNCTION_START;
    
    FormModel *formModel = nil;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", self.tableName, FormName, formName];
    
    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];

    if ([result next])
    {
        formModel = [FormModel new];
        [formModel initWithResultSet:result];
    }
    
    [_database close];
    
    FUNCTION_END;
    
    return formModel;
}

//Return a list of all forms from the database
- (NSArray *)allForms
{
    FUNCTION_START;
    
    FormModel *formModel = nil;
    NSMutableArray *allForms = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", FormTable];
    
    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formModel = [FormModel new];
        [formModel initWithResultSet:result];
        
        [allForms addObject:formModel];
    }
    
    [_database close];
    
    FUNCTION_END;
    return allForms;
}

@end
