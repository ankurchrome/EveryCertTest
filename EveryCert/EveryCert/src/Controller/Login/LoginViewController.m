//
//  LoginViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "ElementTableView.h"
#import "ElementHandler.h"
#import "CompanyUserHandler.h"

@interface LoginViewController ()
{
    NSArray *_loginElements;
    IBOutlet ElementTableView *_loginElementTableView;
}
@end

@implementation LoginViewController

NSString *const ForgotPasswordAlertTitle       = @"Forgot password";
NSString *const ForgotPasswordEmailPlaceholder = @"Email";
NSString *const ForgotPasswordResetActionTitle = @"Reset your password";

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    ElementHandler *elementHandler = [ElementHandler new];
    _loginElements = [elementHandler getLoginElements];
    
    [_loginElementTableView reloadWithElements:_loginElements];
}

#pragma mark - IBActions

//Show an alert to reset the password
- (IBAction)onClickForgetPasswordButton:(id)sender
{
    UIAlertController *alertController = nil;
    UIAlertAction     *resetPasswordAction = nil;
    
    alertController = [UIAlertController alertControllerWithTitle:ForgotPasswordAlertTitle
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = ForgotPasswordEmailPlaceholder;
    }];
    
    resetPasswordAction = [UIAlertAction actionWithTitle:ForgotPasswordResetActionTitle
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action)
    {
        
    }];
    
    [alertController addAction:resetPasswordAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SignIn"])
    {
        CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
        
        BOOL isLoggedIn = [companyUserHandler checkLoginWithElements:_loginElements];
        
        if (!isLoggedIn)
        {
            return NO;
        }
    }
    
    return YES;
}

@end
