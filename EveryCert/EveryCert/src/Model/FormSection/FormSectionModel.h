//
//  FormSectionModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 01/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface FormSectionModel : NSObject

@property (nonatomic, assign) NSInteger sectionId;
@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign) NSInteger sequenceOrder;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *footer;
@property (nonatomic, strong) NSString *title;

@end
