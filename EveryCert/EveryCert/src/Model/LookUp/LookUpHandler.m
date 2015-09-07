//
//  LookUpHandler.m
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookUpHandler.h"

@implementation LookUpHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = LookUpTable;
        self.appIdField    = LookUpIdApp;
        self.serverIdField = LookUpId;
        self.tableColumns  = @[LookUpIdApp, LookUpId, LookUpListId, LookUpRecordIdApp, LookUpLinkedRecordIdApp, LookUpFieldNumber, LookUpOption, LookUpDataValue, LookUpSequenceOrder, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

@end
