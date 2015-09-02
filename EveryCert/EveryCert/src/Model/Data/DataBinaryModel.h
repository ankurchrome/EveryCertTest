//
//  DataBinaryModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface DataBinaryModel : BaseModel

@property (nonatomic, assign) NSInteger dataIdApp;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic, assign) NSInteger certificateIdApp;
@property (nonatomic, assign) NSInteger elementId;
@property (nonatomic, assign) NSData *dataBinary;
@property (nonatomic, assign) NSInteger recordIdApp;
@property (nonatomic, strong) NSData *data;

/**
 This Method is used to initialize the Result Set
 @param  FMResultSet Object of FMResult Set
 @return void
 */
- (void)initWithResultSet:(FMResultSet *)resultSet;

@end
