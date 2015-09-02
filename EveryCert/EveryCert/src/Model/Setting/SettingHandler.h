//
//  SettingHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 15/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "SettingModel.h"

@interface SettingHandler : BaseHandler

/**
 Fetch setting model for logged in engineer
 @param  password Password of logged in engineer
 @return SettingModel setting model object contains the engineer info
 */
- (SettingModel *)settingModelForPassword:(NSString *)password;

/**
 Update engineer's setting information into database
 @param  setting A SettingModel object containing engineer's info
 @return BOOL return YES if setting updated successfully otherwise NO
 */
- (BOOL)updateSetting:(SettingModel *)setting;

@end
