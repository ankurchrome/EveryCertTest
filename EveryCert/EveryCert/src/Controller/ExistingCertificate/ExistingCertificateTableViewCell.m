//
//  ExistingCertificateTableViewCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 10/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ExistingCertificateTableViewCell.h"
#import "CertificateModel.h"

@implementation ExistingCertificateTableViewCell

NSString *const ExistingCertCellReuseIdentifier = @"ExistingCertCellIdentifier";

// Initialize the cell with the given certificate and filled UI controls from the certificate info
- (void)initializeWithCertificate:(CertificateModel *)certificateModel
{
    _certificate = certificateModel;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy hh:mm:ss";
    
    _nameLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:certificateModel.dateTimestamp]];
    
    _nameLabel.textColor = certificateModel.issuedApp ? [UIColor blackColor] : [UIColor redColor];
}

@end
