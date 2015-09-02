//
//  RecordHandler.m
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RecordHandler.h"

@implementation RecordHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = RecordTable;
        self.appIdField    = RecordIdApp;
        self.serverIdField = RecordId;
        self.tableColumns  = @[RecordIdApp, RecordId, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

@end