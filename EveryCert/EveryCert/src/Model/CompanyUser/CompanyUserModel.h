//
//  CompanyUserModel.h
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyUserModel : BaseModel

@property (nonatomic, assign) NSInteger companyUserIdApp;
@property (nonatomic, assign) NSInteger companyUserId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, strong) NSString *data;

@end