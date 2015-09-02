//
//  FormModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface FormModel : NSObject

@property (nonatomic, assign) NSInteger formIdApp;
@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *backgroundLayout;
@property (nonatomic, strong) NSDictionary *companyAttributes;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) double modifiedTimestampApp;
@property (nonatomic, assign) double modifiedTimestamp;
@property (nonatomic, assign) NSInteger archive;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *companyFormat;
@property (nonatomic, strong) NSString *formSequenceOrder;

/**
 This Method is used to initialize the Result Set
 @param  FMResultSet Object of FMResult Set
 @return void
 */
- (void)initWithResultSet:(FMResultSet *)resultSet;

@end