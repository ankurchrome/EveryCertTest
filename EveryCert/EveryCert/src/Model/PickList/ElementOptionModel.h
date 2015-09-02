//
//  ElementOptionModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface ElementOptionModel : BaseModel

@property (nonatomic, assign) NSInteger OptionidApp;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *option;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NSInteger sequenceOrder;

@end