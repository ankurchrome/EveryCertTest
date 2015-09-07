//
//  FormElementHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "ElementModel.h"

@interface ElementHandler : BaseHandler

/**
 Fetch all elements of given form with their stored data(if any) of given cert
 @param formId Form id to identify the form type in element table
 @param certIdApp Certificate id to check the data if exist
 @return NSArray An array of ElementModel objects with their data(if any)
 */
- (NSArray *)getAllElementsOfForm:(NSInteger)formId withDataOfCertificate:(NSInteger)certIdApp;

/**
 Fetch all elements of given form
 @param formId Form id to identify the form type in element table
 @return NSArray An array of ElementModel objects of given form
 */
- (NSArray *)getAllElementsOfForm:(NSInteger)formId;

/**
 Fetch all elements for Login screen from database
 @return NSArray An array of ElementModel objects for Login screen
 */
- (NSArray *)getLoginElements;

/**
 Fetch all elements for SignUp/CreateAccount screen from database
 @return NSArray An array of ElementModel objects for SignUp screen
 */
- (NSArray *)getSignUpElements;

/**
 Fetch all elements of given section from database
 @param  sectionId Section id of element table
 @return NSArray An array of ElementModel objects of given section
 */
- (NSArray *)getAllElementsOfSection:(NSInteger)sectionId;

/**
 Fetch all elements for Setting screen with their data from company_user & data_binary table
 @param  companyId Company Id of logged user
 @return NSArray An array of ElementModel objects with data
 */
- (NSArray *)getSettingElementsOfCompany:(NSInteger)companyId;

@end
