//
//  DataModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface DataModel : BaseModel

@property (nonatomic, assign) NSInteger dataIdApp;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, assign) NSInteger certificateIdApp;
@property (nonatomic, assign) NSInteger elementId;
@property (nonatomic, assign) NSInteger recordIdApp;
@property (nonatomic, strong) NSString  *data;

@end
