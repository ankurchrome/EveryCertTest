//
//  CertificateHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 26/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "CertificateHandler.h"

@implementation CertificateHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName  = CertificateTable;
        self.appIdField = CertificateIdApp;
        self.fieldList  = [[NSArray alloc] initWithObjects:CertificateIdApp, CertificateId, FormIdApp, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId, nil];
    }
    
    return self;
}

// Insert a certificate object into certificate table.
- (BOOL)insertCertificate:(CertificateModel *)certificate
{
    certificate.modifiedTimestamp = [[NSDate date] timeIntervalSince1970];
    
    [_database open];
    
   NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", CertificateTable, CertificateIdApp, CertificateId, CertificateFormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId];

    BOOL isExecuted = [_database executeUpdate:query, @(certificate.certIdApp), @(certificate.certId), @(certificate.formId), certificate.name, certificate.issuedApp, certificate.date, certificate.pdf, @(certificate.modifiedTimestamp), certificate.modifiedTimestampApp, @(certificate.archive), certificate.uuid, @(certificate.isDirty), certificate.companyId];
    
//    BOOL isExecuted = [_database executeUpdate:query, @(certificate.certIdApp), @(certificate.formIdApp), certificate.name, @(certificate.issuedApp), @(certificate.date), @(certificate.modifiedTimestamp), certificate.date, certificate.pdf];
//    
    if (isExecuted)
    {
        certificate.certIdApp = (int)[_database lastInsertRowId];
    }
    
    [_database close];
    
    return isExecuted;
}

// Update certificate information into its database table
- (BOOL)updateCertificate:(CertificateModel *)certificate
{
    certificate.modifiedTimestamp = [[NSDate date] timeIntervalSince1970];
    
    [_database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName,CertificateIdApp, CertificateId, CertificateFormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, UUid, IsDirty, CompanyId, CertificateIdApp];
    
    
    BOOL isExecuted = [_database executeUpdate:query, @(certificate.certIdApp), @(certificate.certId), @(certificate.formId), certificate.name, certificate.issuedApp, certificate.date, certificate.pdf, certificate.modifiedTimestamp, certificate.modifiedTimestampApp, @(certificate.archive), certificate.uuid, @(certificate.isDirty), certificate.companyId, @(certificate.certIdApp)];
    
    [_database close];
    
    return isExecuted;
}

// Fetch all the existing certificates from the database
- (NSArray *)allExistingCertificates
{
    CertificateModel *certificateModel = nil;
    NSMutableArray *certificateModelList = [NSMutableArray new];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", self.tableName, ModifiedTimestampApp];
    
    [_database open];
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        certificateModel = [CertificateModel new];
        [certificateModel initWithResultSet:result];
        [certificateModelList addObject:certificateModel];
    }
    
    [_database close];
    
    FUNCTION_END;
    
    return certificateModelList;
}

@end
