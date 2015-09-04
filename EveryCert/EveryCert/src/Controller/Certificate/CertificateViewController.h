//
//  CertificateViewController.h
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificateModel;

@interface CertificateViewController : UIViewController

/**
 Initialize CertificateViewController with CertificateModel object
 @param  certificate CertificateModel object containing info about certificate
 @return void
 */
- (void)initializeWithCertificate:(CertificateModel *)certificate;


@end
