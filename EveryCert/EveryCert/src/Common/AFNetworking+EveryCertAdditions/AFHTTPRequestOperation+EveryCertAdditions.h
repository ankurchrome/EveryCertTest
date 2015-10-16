//
//  AFHTTPRequestOperation+EveryCertAdditions.h
//  EveryCert
//
//  Created by Ankur Pachauri on 16/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperation_EveryCertExtension.h"

@interface AFHTTPRequestOperation (EveryCertAdditions)

/**
 Validate the response of request operation(AFURLConnectionOperation) against a known common format being used by EveryCert Server
 @return returns YES if response is valid and no error found otherwise returns NO
 */
- (BOOL)validateResponse;

@end
