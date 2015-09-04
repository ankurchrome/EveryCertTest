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

@end
