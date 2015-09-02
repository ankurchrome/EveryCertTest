//
//  SettingHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 15/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "SettingHandler.h"

@implementation SettingHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName  = SettingTable;
        self.appIdField = SettingIdApp;
        self.fieldList  = [[NSArray alloc] initWithObjects:SettingIdApp, SettingEngineerEmail, SettingEngineerPassword, SettingEngineerName, SettingEngineerSign, nil];
    }
    
    return self;
}

// Fetch setting info for logged in technician
- (SettingModel *)settingModelForPassword:(NSString *)password
{
    FUNCTION_START;
    
    SettingModel *settingModel = nil;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", SettingTable, SettingEngineerPassword, password];
    
    [_database open];
    
    FMResultSet *resultSet = [_database executeQuery:query];
    
    if ([resultSet next])
    {
        settingModel = [SettingModel new];
        
        settingModel.settingIdApp = [resultSet intForColumn:SettingIdApp];
        settingModel.enggEmail    = [resultSet stringForColumn:SettingEngineerEmail];
        settingModel.enggPassword = [resultSet stringForColumn:SettingEngineerPassword];
        settingModel.enggName     = [resultSet stringForColumn:SettingEngineerName];
        settingModel.enggSign     = [resultSet dataForColumn:SettingEngineerSign];
    }
    
    [_database close];
    
    
    FUNCTION_END;
    return settingModel;
}

// Update engineer's setting information into database
- (BOOL)updateSetting:(SettingModel *)setting
{
    [_database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, SettingEngineerEmail, SettingEngineerName, SettingEngineerSign, SettingEngineerPassword];
    
    BOOL isExecuted = [_database executeUpdate:query, setting.enggEmail, setting.enggName, setting.enggSign, setting.enggPassword];
    
    [_database close];
    
    return isExecuted;
}

@end
