//
//  LookUpModel.h
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseModel.h"

@interface LookUpModel : BaseModel

@property (nonatomic, assign) NSInteger lookUpIdApp;
@property (nonatomic, assign) NSInteger lookUpId;
@property (nonatomic, assign) NSInteger lookUpListId;
@property (nonatomic, assign) NSInteger recordIdApp;
@property (nonatomic, assign) NSInteger linkedRecordIdApp;
@property (nonatomic, assign) NSInteger fieldNumber;
@property (nonatomic, strong) NSString  *option;
@property (nonatomic, strong) NSString  *dataValue;
@property (nonatomic, assign) NSInteger sequenceOrder;

/**
 Create LookUpModel object and initialized it with specified resultset
 @param  FMResultSet Object of FMResult Set
 @return void
 */
- (void)initWithResultSet:(FMResultSet *)resultSet;

@end
