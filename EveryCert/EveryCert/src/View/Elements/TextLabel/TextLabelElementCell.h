//
//  TextLabelElementCell.h
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableViewCell.h"
#import "FormSectionModel.h"
#import "CertificateModel.h"

@interface TextLabelElementCell : ElementTableViewCell

/**
 Initialize Cell Element with their information
 @param  FormElementModel object which contains info like section, title etc.
 @return id initialize a cell
 */
- (TextLabelElementCell *)initWithModel:(ElementModel *)formElement;

/**
 This mehtod is used to initialize the TextLabelElement Cell with the Section Model
 @param FormSectionModel Contains all the property of Form Section Model
 @return TextLabelElementCell Object that contains cell containing Label
 */
- (TextLabelElementCell *)initWithSectionModel:(FormSectionModel *)sectionElement;

/**
 This Method is u=sed to initialize the TextLabelElement Cell with the Section Model
 @param  CertificateModel Contains all the property of Form certificateModel
 @return TextLabelElementCell Object that contains cell containing label
 */
- (TextLabelElementCell *)initWithCertificateModel:(CertificateModel *)certificateModel;

@end
