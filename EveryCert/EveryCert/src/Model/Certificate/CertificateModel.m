//
//  CertificateModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 26/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "CertificateModel.h"

@implementation CertificateModel

//Returns a path where certificate will be save/already saved.
- (NSString *)pdfPath
{
    FUNCTION_START;
    
    NSString *certPdfName = [NSString stringWithFormat:@"%@-%ld", self.name, (long)self.certIdApp];
    
    NSString *pdfPath = [FORMS_DIR stringByAppendingPathComponent:certPdfName];
    pdfPath = [pdfPath stringByAppendingPathExtension:PDF_EXTENSION];
    
    FUNCTION_END;
    return pdfPath;
}

// This Method is used to Set all Model's Properties with the Result Set
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    [super initWithResultSet:resultSet];
    if (resultSet)
    {
        self.certIdApp = [resultSet intForColumn:CertificateIdApp];
        self.certId    = [resultSet intForColumn:CertificateId];
        self.formId    = [resultSet intForColumn:FormId];
        self.name      = [resultSet stringForColumn:CertificateName];
        self.issuedApp = [resultSet boolForColumn:CertificateIssuedApp];
        self.date      = [resultSet dateForColumn:CertificateDate];
        self.pdf       = [resultSet stringForColumn:CertificatePdf];
    }
}
@end
