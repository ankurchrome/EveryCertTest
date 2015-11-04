//
//  FMDBDataSource.h
//  EveryCert
//
//  Created by Ankur Pachauri on 04/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBDataSource : NSObject

/**
 Returns a singleton FMDBDataSource object and initialized with Database connection
 @return Returns a FMDBDataSource object
 */
+ (id)sharedManager;

// Returns a singleton FMDatabase object
+ (id)sharedDatabase;

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end
