//
//  ECHttpClient.h
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ECHttpClient : AFHTTPSessionManager

+ (ECHttpClient *)sharedHttpClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

@end
