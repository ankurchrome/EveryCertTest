//
//  FormModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface FormModel : BaseModel

@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *backgroundLayout;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSDictionary *companyFormat;
@property (nonatomic, assign) NSInteger sequenceOrder;
@property (nonatomic, assign) NSInteger permissionGroup;

@end
