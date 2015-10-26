//
//  ECHttpClient.m
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ECHttpClient.h"

@implementation ECHttpClient

+ (ECHttpClient *)sharedHttpClient;
{
    static ECHttpClient *_sharedHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      _sharedHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:EveryCertBaseUrl]];
                  });
    
    return _sharedHttpClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    
    return self;
}

@end
