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
    __block NSInteger rowId = 0;
    
    certificate.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    certificate.isDirty = true;
    certificate.uuid = [[NSUUID new] UUIDString];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        BOOL success = false;
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", self.tableName, FormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId];
        
        success = [db executeUpdate:query, @(certificate.formId), certificate.name, @(certificate.issuedApp).stringValue, certificate.date, certificate.pdf, @(certificate.modifiedTimestamp).stringValue, @(certificate.modifiedTimestampApp).stringValue, @(certificate.archive), certificate.uuid, @(certificate.isDirty), @(certificate.companyId).stringValue];
        
        if (success)
        {
            rowId = (NSInteger)[db lastInsertRowId];
        }
    }];
    
    return rowId;
}

// Update certificate information into its database table
- (BOOL)updateCertificate:(CertificateModel *)certificate
{
    __block BOOL success = false;

    certificate.isDirty = true;
    certificate.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, CertificateId, FormId, CertificateName, CertificateIssuedApp, CertificateDate, CertificatePdf, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, CertificateIdApp];
        
        success = [db executeUpdate:query, @(certificate.certId), @(certificate.formId), certificate.name, certificate.issuedApp, certificate.date, certificate.pdf, certificate.modifiedTimestamp, certificate.modifiedTimestampApp, @(certificate.archive), certificate.uuid, @(certificate.isDirty), certificate.companyId, @(certificate.certIdApp)];
    }];
    
    return success;
}

// Fetch all the existing certificates of given company
- (NSArray *)getAllExistingCertificatesOfCompany:(NSInteger)companyId
{
    FMDatabaseQueue *databaseQueue        = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *certificateModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = nil;
         FMResultSet *result = nil;
         CertificateModel *certificateModel = nil;

         query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@ DESC", self.tableName, CompanyId, (long)companyId, Archive, ModifiedTimestampApp];
         
         result = [db executeQuery:query];
         
         while ([result next])
         {
             certificateModel = [[CertificateModel alloc] initWithResultSet:result];
             
             [certificateModelList addObject:certificateModel];
         }
     }];
    
    return certificateModelList;
}

@end
