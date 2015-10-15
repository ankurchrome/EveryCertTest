//
//  AFURLConnectionOperation+EveryCertAdditions.m
//  EveryCert
//
//  Created by Ankur Pachauri on 15/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "AFURLConnectionOperation+EveryCertAdditions.h"

@implementation AFURLConnectionOperation (EveryCertAdditions)

//  Validate the response of request operation(AFURLConnectionOperation) against a known common format being used by EveryCert Server
- (void)validateResponse
{
    NSDictionary *responseInfo = nil;
    NSError *error = nil;
    
    [self clearResponseData];
    
    if (!self.responseData)
    {
        if (LOGS_ON) NSLog(@"Response not found"); return;
    }
    
    responseInfo = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    if (error)
    {
        if (LOGS_ON) NSLog(@"Response JSON is not valid: %@", error.localizedDescription);
        if (LOGS_ON) NSLog(@"Response: %@", self.responseString);
        
        return;
    }

    if (LOGS_ON) NSLog(@"Response: %@", responseInfo);
    
    self.isResponseValid = YES;
    self.metadataInfo    = [responseInfo valueForKey:ApiResponseKeyMetadata];
    self.payloadInfo     = [responseInfo valueForKey:ApiResponseKeyPayload];
    self.numberOfRecords = [[responseInfo valueForKey:ApiResponseKeyNoOfRecords] integerValue];
    
    if (self.metadataInfo)
    {
        self.metadataError = [[self.metadataInfo valueForKey:ApiResponseKeyMetadataError] boolValue];
        self.metadataTimestamp = [[self.metadataInfo valueForKey:ApiResponseKeyMetadataTimestamp] doubleValue];
        
        if (self.metadataError && self.payloadInfo)
        {
            self.popupMessage = [self.payloadInfo objectForKey:ApiResponseKeyPayloadPopupMessage];
        }
    }
}

// Clear data of all fields(extended in EveryCertExtension)
- (void)clearResponseData
{
    self.isResponseValid = NO;
    self.metadataInfo = nil;
    self.payloadInfo = nil;
    self.metadataError = false;
    self.metadataTimestamp = 0;
    self.numberOfRecords = 0;
    self.popupMessage = nil;
}

@end
