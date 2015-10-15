//
//  AFURLConnectionOperation_EveryCertExtension.h
//  EveryCert
//
//  Created by Ankur Pachauri on 15/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFURLConnectionOperation.h"

@interface AFURLConnectionOperation ()

@property (nonatomic, strong) NSDictionary *metadataInfo;
@property (nonatomic, strong) NSDictionary *payloadInfo;
@property (nonatomic, assign) BOOL metadataError;
@property (nonatomic, assign) BOOL isResponseValid;
@property (nonatomic, assign) NSTimeInterval metadataTimestamp;
@property (nonatomic, assign) NSInteger numberOfRecords;
@property (nonatomic, copy)   NSString *popupMessage;

@end
