//
//  ElementOptionHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementOptionHandler.h"

@implementation ElementOptionHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName  = PickListOptionTable;
        self.appIdField = PickListOptionIdApp;
        self.fieldList  = [[NSArray alloc] initWithObjects:PickListOptionIdApp, PickListOptionType, PickListOptionName, PickListOptionValue, PickListOptionSequenceOrder, FormSectionFooter, nil];
    }
    
    return self;
}

// Fetch all options for given type of pick list.
- (NSArray *)allOptionsOfPickListType:(NSInteger)pickListType
{
    FUNCTION_START;
    
    ElementOptionModel *elementOptionModel = nil;
    NSMutableArray *elementOptionList = [NSMutableArray new];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld ORDER BY sequence_order", self.tableName, PickListOptionType, (long)pickListType];
    
    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        elementOptionModel = [self elementOptionModelsFromResultSet:result];
        
        [elementOptionList addObject:elementOptionModel];
    }
    
    [_database close];
    
    FUNCTION_END;
    
    return elementOptionList;
}

// Create ElementOptionModel object and initialized it with specified resultset
- (ElementOptionModel *)elementOptionModelsFromResultSet:(FMResultSet *)resultSet
{
    ElementOptionModel *elementOptionModel = [ElementOptionModel new];
    
    if (resultSet)
    {
        elementOptionModel.OptionidApp  = [resultSet intForColumn:PickListOptionIdApp];
        elementOptionModel.type   = [resultSet intForColumn:PickListOptionType];
        elementOptionModel.option = [resultSet stringForColumn:PickListOptionName];
        elementOptionModel.value  = [resultSet stringForColumn:PickListOptionValue];
        elementOptionModel.sequenceOrder = [resultSet intForColumn:PickListOptionSequenceOrder];
    }
    
    return elementOptionModel;
}

// This Method is used to get All Type of Burners
- (NSArray *)getAllBurnerType
{
    NSMutableArray *burnerTypeArray = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", BurnerTypeTable];
    [_database open];
    FMResultSet *resultSet = [_database executeQuery:query];
    while ([resultSet next]) {
        [burnerTypeArray addObject:[resultSet resultDictionary]];
    }
    return burnerTypeArray;
}
@end
