//
//  CertificateModel.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 26/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseModel.h"

@interface CertificateModel : BaseModel

@property (nonatomic, assign) NSInteger certIdApp;
@property (nonatomic, assign) NSInteger certId;
@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL      issuedApp;
@property (nonatomic, assign) double    dateTimestamp;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSString *pdf;

//TODO: check if this method is needed
/**
 Returns a path where certificate will be save/already saved.
 @return NSString A path to certificate pdf
 */
- (NSString *)pdfPath;

@end