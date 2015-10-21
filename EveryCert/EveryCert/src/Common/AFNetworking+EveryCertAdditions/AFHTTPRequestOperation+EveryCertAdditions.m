//
//  AFHTTPRequestOperation+EveryCertAdditions.m
//  EveryCert
//
//  Created by Ankur Pachauri on 16/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFHTTPRequestOperation+EveryCertAdditions.h"

@implementation AFHTTPRequestOperation (EveryCertAdditions)

//  Validate the response of request operation(AFURLConnectionOperation) against a known common format being used by EveryCert Server
- (BOOL)validateResponse
{
    BOOL isValid = NO;

    if (LOGS_ON) NSLog(@"Response: %@", self.responseObject);
    
    if (!self.responseObject || ![self.responseObject isKindOfClass:[NSDictionary class]])
    {
        if (LOGS_ON) NSLog(@"Response not found"); return isValid;
    }

    NSDictionary *metadataInfo = [self.responseObject valueForKey:ApiResponseKeyMetadata];
    NSDictionary *payloadInfo  = [self.responseObject valueForKey:ApiResponseKeyPayload];
    
    if (metadataInfo)
    {
        BOOL error = [[metadataInfo valueForKey:ApiResponseKeyMetadataError] boolValue];
        
        if (error && payloadInfo)
        {
            NSString *popupMessage = [payloadInfo objectForKey:ApiResponseKeyPayloadPopupMessage];

            [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED message:popupMessage];
            
            return isValid;
        }
    }
    
    return isValid = YES;
}

- (NSDictionary *)metadataInfo
{
    return [self.responseObject valueForKey:ApiResponseKeyMetadata];
}

- (id)payloadInfo
{
    return [self.responseObject valueForKey:ApiResponseKeyPayload];
}

- (NSInteger)numberOfRecords
{
    return [[self.responseObject valueForKey:ApiResponseKeyNoOfRecords] integerValue];
}

- (NSTimeInterval)metadataTimestamp
{
    NSTimeInterval timestamp;
    
    NSDictionary *metadataInfo = [self.responseObject valueForKey:ApiResponseKeyMetadata];
    
    if (metadataInfo)
    {
        timestamp = [[metadataInfo objectForKey:ApiResponseKeyMetadataTimestamp] doubleValue];
    }
    
    return timestamp;
}

@end
