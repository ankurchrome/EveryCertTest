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

- (void)initializeWithCertificate:(CertificateModel *)certificate;

@end
