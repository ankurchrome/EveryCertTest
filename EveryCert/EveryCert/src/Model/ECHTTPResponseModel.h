//
//  ECHttpResponseModel.h
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECHttpResponseModel : NSObject

- (id)initWithResponseInfo:(NSDictionary *)responseInfo;

@property (nonatomic, strong) NSDictionary *responseInfo;
@property (nonatomic, strong) NSDictionary *metadataInfo;
@property (nonatomic, strong) id            payloadInfo;

@property (nonatomic, strong) NSError  *error;
@property (nonatomic, copy)   NSString *popupMessage;
@property (nonatomic, assign) NSTimeInterval metadataTimestamp;

@end
