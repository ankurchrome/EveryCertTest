//
//  DataBinaryModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface DataBinaryModel : BaseModel

@property (nonatomic, assign) NSInteger dataBinaryIdApp;
@property (nonatomic, assign) NSInteger dataBinaryId;
@property (nonatomic, assign) NSInteger certificateIdApp;
@property (nonatomic, assign) NSInteger elementId;
@property (nonatomic, assign) NSData   *dataBinary;
@property (nonatomic, strong) NSString *fileName;

@end