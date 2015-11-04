//
//  FMDBDataSource.m
//  EveryCert
//
//  Created by Ankur Pachauri on 04/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FMDBDataSource.h"

@implementation FMDBDataSource

// Returns a singleton FMDBDataSource object and initialized with Database connection
+ (id)sharedManager
{
    static FMDBDataSource *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *databasePath = [[CommonUtils getDocumentDirPath] stringByAppendingPathComponent:DATABASE_NAME];
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    }
    return self;
}

// Returns a singleton FMDatabase object
+ (id)sharedDatabase
{
    static FMDatabase *sharedDatabase = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        NSString *databasePath = [[CommonUtils getDocumentDirPath] stringByAppendingPathComponent:DATABASE_NAME];
        sharedDatabase = [FMDatabase databaseWithPath:databasePath];
    });
    
    return sharedDatabase;
}

@end
