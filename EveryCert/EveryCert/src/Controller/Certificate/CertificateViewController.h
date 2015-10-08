//
//  CertificateViewController.h
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormModel, CertificateModel;

@interface CertificateViewController : UIViewController

/**
 Initialize CertificateViewController by creating a new certificate of given form type
 @param  form A FormModel object will be used to create a new certificate
 @return void
 */
- (void)initializeWithForm:(FormModel *)form;

/**
 Initialize CertificateViewController with given existing certificate
 @param  certificate CertificateModel object containing info about certificate
 @return void
 */
- (void)initializeWithCertificate:(CertificateModel *)certificate;

- (void)setupForSelectedLookupRecord:(NSInteger)recordIdApp;

- (void)setupForNewLookupRecord;

@end
