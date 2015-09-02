//
//  CertificateHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 26/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "CertificateModel.h"

@interface CertificateHandler : BaseHandler

/**
 Insert a certificate object into certificate table.
 @param  certificate A certificate model containing info about the cert
 @return NSInteger return a valid row id if certificate saved successfully otherwise return 0
 */
- (NSInteger)insertCertificate:(CertificateModel *)certificate;

/**
 Update certificate information into its database table
 @param  certificate A certificate model containing certificate info
 @return BOOL return YES if certificate updated successfully otherwise NO
 */
- (BOOL)updateCertificate:(CertificateModel *)certificate;

/**
 Fetch all the existing certificates of given company
 @param  companyId CompanyId stored in certificate table to get all certificates
 @return NSArray returns a list of existing certificates
 */
- (NSArray *)getAllExistingCertificatesOfCompany:(NSInteger)companyId;

@end
