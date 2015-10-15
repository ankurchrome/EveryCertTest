//
//  AFURLConnectionOperation+EveryCertAdditions.h
//  EveryCert
//
//  Created by Ankur Pachauri on 15/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFURLConnectionOperation.h"
#import "AFURLConnectionOperation_EveryCertExtension.h"

@interface AFURLConnectionOperation (EveryCertAdditions)

/**
 Validate the response of request operation(AFURLConnectionOperation) against a known common format being used by EveryCert Server
 @return void
 */
- (void)validateResponse;

@end
