//
//  ExistingCertificateTableViewCell.h
//  EveryCert
//
//  Created by Ankur Pachauri on 10/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificateModel;

@interface ExistingCertificateTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) CertificateModel *certificate;

- (void)initializeWithCertificate:(CertificateModel *)certificateModel;

extern NSString *const ExistingCertCellReuseIdentifier;

@end