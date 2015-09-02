//
//  BaseHandler.h
//  Volunteer
//
//  Created by Ankur Pachauri on 14/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BaseHandler : NSObject
{
    @protected
    
    FMDatabase *_database;
}

@property(nonatomic, strong) NSString *tableName;
@property(nonatomic, strong) NSString *appIdField;
@property(nonatomic, strong) NSString *serverIdField;
@property(nonatomic, strong) NSArray  *fieldList;

@end
