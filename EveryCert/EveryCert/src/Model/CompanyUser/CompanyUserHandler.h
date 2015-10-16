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
 <#description#>
 @param  <#type#> <#desc#>
 @return <#type#> <#retval#>
 */
- (void)saveCompanyUserFields:(NSArray *)companyUserFields;

@end
