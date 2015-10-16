//
//  AFHTTPRequestOperation_EveryCertExtension.h
//  EveryCert
//
//  Created by Ankur Pachauri on 16/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface AFHTTPRequestOperation ()

@property (nonatomic, strong) id   payloadInfo;
@property (nonatomic, assign) NSInteger numberOfRecords;
@property (nonatomic, strong) NSDictionary *metadataInfo;
@property (nonatomic, assign) NSTimeInterval metadataTimestamp;

@end
