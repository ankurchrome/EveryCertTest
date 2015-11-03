//
//  ExistingCertificateTableViewCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 10/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ExistingCertificateTableViewCell.h"
#import "CertificateModel.h"
#import "DataHandler.h"

@implementation ExistingCertificateTableViewCell

NSString *const ExistingCertCellReuseIdentifier = @"ExistingCertCellIdentifier";

// Initialize the cell with the given certificate and filled UI controls from the certificate info
- (void)initializeWithCertificate:(CertificateModel *)certificateModel
{
    _certificate = certificateModel;
    
    NSMutableString *nameLabelString = [NSMutableString new];
    NSDateFormatter *dateFormatter   = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yy hh:mm";
    
    DataHandler *dataHandler = [DataHandler new];
    NSString *customerName = [dataHandler getDataFromCertModel: certificateModel FieldName:@"customer_name"];
    
    [nameLabelString appendFormat:@"%@ ",customerName];

    
    // Extract the Certificate Creation Date
    if([CommonUtils isValidString:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:certificateModel.dateTimestamp]]])
    {
        [nameLabelString appendFormat:@"%@ ",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:certificateModel.dateTimestamp]]];
    }
    
    // Extract the Certificate Name
    if([CommonUtils isValidString: certificateModel.name])
    {
        [nameLabelString appendFormat:@"%@ ",certificateModel.name];
    }
    
    _nameLabel.text = nameLabelString;
    _nameLabel.textColor = certificateModel.issuedApp ? [UIColor blackColor] : [UIColor redColor];
}

@end
