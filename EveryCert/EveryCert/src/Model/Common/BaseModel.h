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

@property (nonatomic, assign) NSInteger archive;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) NSInteger isDirty;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) double modifiedTimestampApp;
@property (nonatomic, assign) double modifiedTimestamp;

/**
 This Method is used to Initialize a Model object with the specified Result Set
 @param  FMResultSet An object containing info of a Model
 @return An initialized BaseModel type object
 */
- (id)initWithResultSet: (FMResultSet *)resultSet;

/**
 Initialize object with the info stored in ResultSet
 @param  FMResultSet An object containing info of a Model
 @return void
 */
- (void)setFromResultSet: (FMResultSet *)resultSet;

@end