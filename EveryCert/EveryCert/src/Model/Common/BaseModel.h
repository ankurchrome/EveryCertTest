//
//  BaseModel.h
//  Volunteer
//
//  Created by Ankur Pachauri on 13/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BaseModel : NSObject

//TODO:
//1. Override description to all models

@property (nonatomic, assign) double modifiedTimestampApp;
@property (nonatomic, assign) double modifiedTimestamp;
@property (nonatomic, assign) NSInteger archive;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) NSInteger isDirty;
@property (nonatomic, assign) NSInteger companyId;

/**
 This Method is used to Initialize Model with the Result Set
 @param  FMResultSet Returns the object of FMResult set
 @return void
 */
- (void)initWithResultSet: (FMResultSet *)resultSet;

@end
