//
//  CertificateViewController.h
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormModel, CertificateModel;

@interface CertViewController : UIViewController

@property (nonatomic, strong) CertificateModel  *certificate;
@property (nonatomic, strong) NSArray *formElements;

/**
 Initialize CertificateViewController by creating a new certificate of given form type
 @param  form A FormModel object will be used to create a new certificate
 @return void
 */
- (void)initializeWithForm:(FormModel *)formModel;

/**
 Initialize CertificateViewController with given existing certificate
 @param  certificate CertificateModel object containing info about certificate
 @return void
 */
- (void)initializeWithCertificate:(CertificateModel *)certificate;

/**
 Called when a record gets selected from lookup list and then following steps will be occur
 1. Delete the previously selected record if any.
 2. Fill the selected record field values to their corresponding elements
 @param  recordIdApp It identify the selected lookup record
 @return void
 */
- (void)setupForSelectedLookupRecord:(NSInteger)recordIdApp;

/**
 Called when New button tapped from lookup list and then following steps will be occur
 1. Delete the previously selected record if any.
 2. Remove data from all elements
 @return void
 */
- (void)setupForNewLookupRecord;

/**
 Move to previous section of form
 @return void
 */
- (void)backToPreviousSection;

@end
