//
//  CertificateModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 26/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "CertificateModel.h"

@implementation CertificateModel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _name = EMPTY_STRING;
        _date = [NSDate date];
//        _dateString = EMPTY_STRING;
        _pdf = EMPTY_STRING;
    }
    
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    [super setFromResultSet:resultSet];
    
    if (resultSet)
    {
        self.certIdApp     = [resultSet intForColumn:CertificateIdApp];
        self.certId        = [resultSet intForColumn:CertificateId];
        self.formId        = [resultSet intForColumn:FormId];
        self.name          = [resultSet stringForColumn:CertificateName];
        self.issuedApp     = [resultSet boolForColumn:CertificateIssuedApp];
        self.dateTimestamp = [resultSet doubleForColumn:CertificateDate];
        self.pdf           = [resultSet stringForColumn:CertificatePdf];
    }
}

//Returns a path where certificate will be save/already saved.
- (NSString *)pdfPath
{
    FUNCTION_START;
    
    NSString *certPdfName = [NSString stringWithFormat:@"%@-%ld", self.name, (long)self.certIdApp];
    NSString *pdfPath = [CERTIFICATES_PDF_DIR stringByAppendingPathComponent:certPdfName];
    pdfPath = [pdfPath stringByAppendingPathExtension:FILE_TYPE_PDF];
    
    FUNCTION_END;
    return pdfPath;
}

//Returns a path where form pdf is saved.
- (NSURL *)backgroundPdfPath;
{
    FUNCTION_START;
    
    NSString *formPdfName = [NSString stringWithFormat:@"%ld", self.formId];
    NSString *pdfPath = [FORMS_BACKGROUND_LAYOUT_DIR stringByAppendingPathComponent:formPdfName];
    pdfPath = [pdfPath stringByAppendingPathExtension:FILE_TYPE_PDF];
    
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfPath];
    
    FUNCTION_END;
    return pdfUrl;
}

@end
