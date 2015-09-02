//
//  SubElementModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 01/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementModel.h"

@interface SubElementModel : NSObject

@property (assign, nonatomic) NSInteger subElementId;
@property (assign, nonatomic) NSInteger elementId;
@property (assign, nonatomic) NSInteger formId;
@property (assign, nonatomic) NSInteger fieldType;
@property (strong, nonatomic) NSString  *fieldName;
@property (assign, nonatomic) NSInteger sequenceOrder;
@property (strong, nonatomic) NSString  *label;
@property (assign, nonatomic) NSInteger originX;
@property (assign, nonatomic) NSInteger originY;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) NSInteger minCharLimit;
@property (assign, nonatomic) NSInteger maxCharLimit;
@property (strong, nonatomic) NSDictionary *printedTextFormat;
@property (assign, nonatomic) NSInteger linkedElementId;
@property (strong, nonatomic) NSString  *modifiedTimestamp;
@property (assign, nonatomic) NSInteger archive;
@property (strong, nonatomic) NSString  *popUpMessage;
@property (assign, nonatomic) NSInteger lookUpIdNew;
@property (assign, nonatomic) NSInteger fieldNumberNew;
@property (assign, nonatomic) NSInteger lookUpIdExisting;
@property (assign, nonatomic) NSInteger fieldNumberExisting;
@property (strong, nonatomic) NSArray *subElements;
@property (strong, nonatomic) NSString *dataValue;
@property (strong, nonatomic) NSData   *dataBinary;

@end
