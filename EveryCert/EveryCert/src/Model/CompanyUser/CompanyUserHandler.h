//
//  CompanyUserHandler.h
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseHandler.h"
#import "CompanyUserModel.h"

@interface CompanyUserHandler : BaseHandler

/**
 Insert a CompanyUserModel object information into company_user table
 @param  companyUser A CompanyUserModel object containing info about the user of a company
 @return BOOL return Yes if CompanyUserModel saved successfully otherwise No
 */
- (BOOL)insertCompanyUser:(CompanyUserModel *)companyUser;

/**
 Update a CompanyUserModel object information into company_user table.
 @param  companyUser A CompanyUserModel containing info about the user of a company
 @return BOOL return Yes if CompanyUserModel updated successfully otherwise No
 */
- (BOOL)updateCompanyUser:(CompanyUserModel *)companyUser;

/**
 Check login at the app with given elements
 @param  elements A list of ElementModels containing elements like user_email, user_password
 @return Returns true if all elements matches otherwise false
 */
- (BOOL)checkLoginWithElements:(NSArray *)elements;

/**
 Fetch logged user data from database and store it so it can be use throughout the app
 @param  userId User id of logged user
 @return void
 */
- (void)saveLoggedUser:(NSInteger)userId;

/**
 Thsi Mehtod is used to save the Company User Field
 @param  NSArray parameter of Comapny Array Field
 */
- (void)saveCompanyUserFields:(NSArray *)companyUserFields;

///**
// Returns the List of FromId that have Status 1 for Respective Logged UserId and Comapny id
// @return NSArray returns the list of form id
// */
//- (NSArray *)getDataForUserFormStatus;

/**
 Fetch all Record from the Company User Table with respect to the Company User Model
 @param  NSString  Fetch all Record Corresponding to the Field Name
 @param  NSInteger Fetch all Record Corresponding to the Logged User Comapany Id
 @param  NSInteger Fetch all Record Corresponding to the Logged User Id
 @return CompanyUserModel Returns CompanyUserModel Model
 */
- (CompanyUserModel *)getCompanyUserModelForFieldName:(NSString *)fieldName ComapnyId:(NSInteger )companyId UserId:(NSInteger)userId;

@end
