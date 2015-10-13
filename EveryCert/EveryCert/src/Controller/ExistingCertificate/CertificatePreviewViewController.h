//
//  CertificatePreviewViewController.h
//  EveryCert
//
//  Created by Ankur Pachauri on 27/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificateModel;

@interface CertificatePreviewViewController : UIViewController

/**
 Initialize the cell with the given certificate and show its pdf. Also allow the user to edit, delete and share the certificate.
 @param  certificateModel CertificateModel object containing info about a certificate.
 @return void
 */
- (void)initializeWithCertificate:(CertificateModel *)certificate;

@end
