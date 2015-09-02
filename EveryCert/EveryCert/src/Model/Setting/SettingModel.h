//
//  SettingModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 15/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface SettingModel : NSObject

@property (nonatomic, strong) NSString *enggEmail;
@property (nonatomic, strong) NSString *enggPassword;
@property (nonatomic, strong) NSString *enggName;
@property (nonatomic, strong) NSData   *enggSign;
@property (nonatomic, assign) NSInteger settingIdApp;

@end
