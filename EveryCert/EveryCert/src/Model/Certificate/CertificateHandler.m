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
        self.tableName     = CertificateTable;
        self.appIdField    = CertificateIdApp;
        self.serverIdField = CertificateId;
        self.tableColumns  = @[CertificateIdApp, CertificateId, FormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
    }
    
    return self;
}

// Insert a certificate object into certificate table and returns row id for inserted row
- (NSInteger)insertCertificate:(CertificateModel *)certificate
{
    BOOL success = false;
    NSInteger rowId = 0;
    NSString *query = nil;
    
    certificate.isDirty = true;
    certificate.uuid = [[NSUUID new] UUIDString];
    certificate.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    
   query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", self.tableName, FormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];

    success = [self.database executeUpdate:query, @(certificate.formId), certificate.name, certificate.issuedApp, certificate.date, certificate.pdf, @(certificate.modifiedTimestamp), certificate.modifiedTimestampApp, @(certificate.archive), certificate.uuid, @(certificate.isDirty), certificate.companyId];
    
    if (success)
    {
        rowId = [self.database lastInsertRowId];
    }
    
    return rowId;
}

// Update certificate information into its database table
- (BOOL)updateCertificate:(CertificateModel *)certificate
{
    BOOL success = false;
    NSString *query = nil;
    
    certificate.isDirty = true;
    certificate.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    
    query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, CertificateId, FormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, CertificateIdApp];
    
    success = [self.database executeUpdate:query, @(certificate.certId), @(certificate.formId), certificate.name, certificate.issuedApp, certificate.date, certificate.pdf, certificate.modifiedTimestamp, certificate.modifiedTimestampApp, @(certificate.archive), certificate.uuid, @(certificate.isDirty), certificate.companyId, @(certificate.certIdApp)];
    
    return success;
}

// Fetch all the existing certificates of given company
- (NSArray *)getAllExistingCertificatesOfCompany:(NSInteger)companyId
{
    NSString *query = nil;
    FMResultSet *result = nil;
    CertificateModel *certificateModel = nil;
    NSMutableArray   *certificateModelList = nil;
    
    query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@ DESC", self.tableName, CompanyId, companyId, Archive, ModifiedTimestampApp];
    
    result = [self.database executeQuery:query];

    certificateModelList = [NSMutableArray new];
    
    while ([result next])
    {
        certificateModel = [[CertificateModel alloc] initWithResultSet:result];

        [certificateModelList addObject:certificateModel];
    }
    
    FUNCTION_END;
    
    return certificateModelList;
}

@end
