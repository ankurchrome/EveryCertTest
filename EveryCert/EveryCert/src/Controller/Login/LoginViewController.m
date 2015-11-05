//
//  LoginViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "KeyBoardScrollView.h"
#import "ElementTableView.h"
#import "ElementHandler.h"
#import "CompanyUserHandler.h"
#import "MenuViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "AFHTTPRequestOperation+EveryCertAdditions.h"

@interface LoginViewController ()
{
    IBOutlet KeyBoardScrollView *_bgScrollView;
    IBOutlet UIView             *_contentView;
    IBOutlet ElementTableView   *_loginElementTableView;
    
    NSArray *_loginElements;
}
@end

@implementation LoginViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BG_COLOR;

    ElementHandler *elementHandler = [ElementHandler new];
    _loginElements = [elementHandler getLoginElements];

    //remove keybaord observer from table view as background scroll view has already
    [_loginElementTableView removeObserver];
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frameWidth, CGRectGetMaxY(_contentView.frame));

    _loginElementTableView.clipsToBounds = NO;
    _loginElementTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _loginElementTableView.layer.shadowOffset = CGSizeMake(0,5);
    _loginElementTableView.layer.shadowOpacity = 0.5;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Set user credentials if already logged In
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (ElementModel *element in _loginElements)
    {
        if ([element.fieldName isEqualToString:CompanyUserFieldNameEmail])
        {
            element.dataValue = [userDefaults objectForKey:LoggedUserEmail];
            element.dataValue = @"demo@swfy.co.uk";
        }
        else if ([element.fieldName isEqualToString:CompanyUserFieldNamePassword])
        {
            element.dataValue = [userDefaults objectForKey:LoggedUserPassword];
            element.dataValue = @"password12";
        }
    }
    
    [_loginElementTableView reloadWithElements:_loginElements];
}

- (void)viewDidLayoutSubviews
{
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frameWidth, CGRectGetMaxY(_contentView.frame));
}

#pragma mark -

- (void)startLoginWithServer
{
    //Check for internet availability for login through server
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED
                                message:AlertMessageConnectionNotFound];
        return;
    }
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = HudTitleSignin;

    NSMutableDictionary *loginParams = [NSMutableDictionary new];
    
    for (ElementModel *elementModel in _loginElements)
    {
        [loginParams setObject:elementModel.dataValue forKey:elementModel.fieldName];
    }
    
    CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
    
    //Start the login service
    [companyUserHandler loginWithCredentials:loginParams
                                   onSuccess:^(ECHttpResponseModel *response)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSArray *companyUserFields = response.payloadInfo;
        
        if (companyUserFields && [companyUserFields isKindOfClass:[NSArray class]] && companyUserFields.count > 0)
        {
            [companyUserHandler saveCompanyUserFields:companyUserFields];
            
            //make the user logged in
            NSDictionary *companyUserField = [companyUserFields firstObject];
            NSInteger userId = [[companyUserField objectForKey:UserId] integerValue];
            [companyUserHandler saveLoggedUser:userId];
            
            MenuViewController *menuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuVC"];
            menuVC.isInitialLogin = YES;
            
            [self.navigationController pushViewController:menuVC animated:YES];
        }
    }
                                     onError:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED message:error.localizedDescription];
    }];
}

#pragma mark - IBActions

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SignIn"])
    {
        //If login details is not valid, don't go further
        if (![_loginElementTableView validateElements]) return NO;
        
        CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
        BOOL isLoggedIn = [companyUserHandler checkLoginWithElements:_loginElements];
        
        if (!isLoggedIn)
        {
            [self startLoginWithServer];
            
            return NO;
        }
    }
    
    return YES;
}

//Show an alert to reset the password
- (IBAction)forgetPasswordButtonTapped:(id)sender
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

/**
 Hide the hud when request fails/completes and show the alert with error message if needed.
 @param  errorMessage An error message to show with alert.
 @return showAlert To decide for display an alert or not.
 */
- (void)stopRequestWithTitle:(NSString *)title Message:(NSString *)message alert:(BOOL)showAlert
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (showAlert)
        {
            [CommonUtils showAlertWithTitle:title message:message];
        }
    });
}


@end
