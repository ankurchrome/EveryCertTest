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
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "AFURLConnectionOperation+EveryCertAdditions.h"

@interface LoginViewController ()
{
    IBOutlet KeyBoardScrollView *_bgScrollView;
    IBOutlet UIView             *_contentView;
    IBOutlet ElementTableView   *_loginElementTableView;
    
    NSArray *_loginElements;
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
    
    //Set user credentials if already logged In
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (ElementModel *element in _loginElements)
    {
        if ([element.fieldName isEqualToString:CompanyUserFieldNameEmail])
        {
            element.dataValue = [userDefaults objectForKey:LoggedUserEmail];
        }
        else if ([element.fieldName isEqualToString:CompanyUserFieldNamePassword])
        {
            element.dataValue = [userDefaults objectForKey:LoggedUserPassword];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *baseUrl = [[ServerUrl stringByAppendingPathComponent:ApiPath] stringByAppendingPathComponent:ApiLogin];

    NSMutableDictionary *loginParams = [NSMutableDictionary new];
    
    for (ElementModel *elementModel in _loginElements)
    {
        [loginParams setObject:elementModel.dataValue forKey:elementModel.fieldName];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager PUT:baseUrl
       parameters:loginParams
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [operation validateResponse];
         
         if (operation.isResponseValid)
         {
             if (operation.metadataError)
             {
                 [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED message:operation.popupMessage];
             }
             else
             {
                 
             }
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", operation.responseString);
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark - IBActions

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SignIn"])
    {
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

@end
