//
//  ECHttpResponseModel.m
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ECHttpResponseModel.h"

@implementation ECHttpResponseModel

- (id)initWithResponseInfo:(NSDictionary *)responseInfo
{
    self = [super init];
    
    if (!self) return nil;
    
    [self clearResponse];
    
    if (!responseInfo || ![responseInfo isKindOfClass:[NSDictionary class]])
    {
        if (LOGS_ON) NSLog(@"Response not valid");
        
        NSDictionary *errorInfo = @{
                                    NSLocalizedDescriptionKey: @"Response not valid"
                                    };
        _error = [NSError errorWithDomain:ErrorDomainRequestFailed code:0 userInfo:errorInfo];
        
        return self;
    }
    
    _responseInfo = responseInfo;
    _metadataInfo = [responseInfo valueForKey:ApiResponseKeyMetadata];
    _payloadInfo  = [responseInfo valueForKey:ApiResponseKeyPayload];
    
    if (_metadataInfo)
    {
        _metadataTimestamp = [[_metadataInfo objectForKey:ApiResponseKeyMetadataTimestamp] doubleValue];
        
        if ([[_metadataInfo valueForKey:ApiResponseKeyMetadataError] boolValue])
        {
            _popupMessage = [_payloadInfo objectForKey:ApiResponseKeyPayloadPopupMessage];
            
            if ([CommonUtils isValidString:_popupMessage])
            {
                NSDictionary *errorInfo = @{
                                            NSLocalizedDescriptionKey: _popupMessage
                                            };
                _error = [NSError errorWithDomain:ErrorDomainRequestFailed code:0 userInfo:errorInfo];
            }
        }
    }
    
    return self;
}

- (void)clearResponse
{
    _responseInfo = nil;
    _metadataInfo = nil;
    _payloadInfo = nil;
   
    _error = nil;
    _popupMessage = nil;
    _metadataTimestamp = 0;
}

@end
