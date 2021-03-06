//
//  AppDelegate.h
//  EveryCert
//
//  Created by Ankur Pachauri on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController, CertViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) NSInteger loggedUserId;
@property (assign, nonatomic) NSInteger loggedUserCompanyId;
@property (strong, nonatomic) NSString *loggedUserFullName;
@property (strong, nonatomic) NSString *loggedUserEmail;
@property (strong, nonatomic) NSString *loggedUserPassword;
@property (strong, nonatomic) NSString *loggedUserPermissionGroup;

@property (strong, nonatomic) MenuViewController *homeVC;
@property (strong, nonatomic) CertViewController *certificateVC;

@end