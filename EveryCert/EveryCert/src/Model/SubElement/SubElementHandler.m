//
//  SubElementHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 27/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SubElementHandler.h"

@implementation SubElementHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = SubElementTable;
        self.serverIdField = SubElementId;
        self.tableColumns  = @[SubElementId, ElementId, ElementFieldType, ElementFieldName, ElementSequenceOrder, ElementLabel, ElementOriginX, ElementOriginY, ElementHeight, ElementWidth, ElementPageNumber, ElementMinCharLimit, ElementMaxCharLimit, ElementPrintedTextFormat, ElementPopUpMessage, ElementLookUpListIdNew, ElementFieldNumberNew, ElementLookUpListIdExisting, ElementFieldNumberExisting, ModifiedTimeStamp, Archive];
    }
    
    return self;
}

// Fetch all sub elements of given element
- (NSArray *)getAllSubElementsOfElement:(NSInteger)elementIdApp
{
    NSString        *query = nil;
    FMResultSet     *result = nil;
    SubElementModel *subElementModel = nil;
    NSMutableArray  *subElementModelList = nil;
    
    query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld ORDER BY %@", SubElementTable, ElementId, (long)elementIdApp, ElementSequenceOrder];
    
    result = [self.database executeQuery:query];
    
    subElementModelList = [NSMutableArray new];
    
    while ([result next])
    {
        subElementModel = [[SubElementModel alloc] initWithResultSet:result];
        
        [subElementModelList addObject:subElementModel];
    }
    
    return subElementModelList;
}

@end
