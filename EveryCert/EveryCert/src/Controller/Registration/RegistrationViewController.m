//
//  RegistrationViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ElementTableView.h"
#import "ElementHandler.h"
#import "CompanyUserHandler.h"
#import "MenuViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "AFHTTPRequestOperation+EveryCertAdditions.h"

@interface RegistrationViewController ()
{
    IBOutlet UIScrollView *_bgScrollView;
    IBOutlet UIView *_contentView;
    IBOutlet ElementTableView   *_signupElementTableView;
    IBOutlet NSLayoutConstraint *_signupElementTableHeightConstraint;

    NSArray *_signupElements;
}
@end

@implementation RegistrationViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = APP_BG_COLOR;

    _signupElementTableView.clipsToBounds = NO;
    _signupElementTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _signupElementTableView.layer.shadowOffset = CGSizeMake(0,5);
    _signupElementTableView.layer.shadowOpacity = 0.5;
    
    ElementHandler *elementHandler = [ElementHandler new];
    _signupElements = [elementHandler getSignUpElements];
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frameWidth, CGRectGetMaxY(_contentView.frame));
    [_signupElementTableView removeObserver];
    [_signupElementTableView reloadWithElements:_signupElements];
}

//- (void)viewDidLayoutSubviews
//{
//    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frameWidth, CGRectGetMaxY(_contentView.frame));
//}

#pragma mark - IBActions

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldPerformSegue = YES;
    
    if ([identifier isEqualToString:@"Registration"])
    {
        shouldPerformSegue = NO;
        
        //If login details is not valid, don't go further
        if (![_signupElementTableView validateElements]) return NO;
        
        //Check for internet availability for login through server
        if (![[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED
                                    message:AlertMessageConnectionNotFound];
            return NO;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableArray *signupParams = [NSMutableArray new];
        
        for (ElementModel *elementModel in _signupElements)
        {
            NSMutableDictionary *elementInfo = [NSMutableDictionary new];
            
            [elementInfo setObject:[[NSUUID new] UUIDString] forKey:Uuid];
            [elementInfo setObject:elementModel.fieldName    forKey:ElementFieldName];
            [elementInfo setObject:elementModel.dataValue    forKey:CompanyUserData];
            
            [signupParams addObject:elementInfo];
        }

        CompanyUserHandler *companyUserHandler = [CompanyUserHandler new];
        
        //Start the signup service
        [companyUserHandler signupWithInfo:signupParams
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
                 
                 [self.navigationController pushViewController:menuVC animated:YES];
             }
         }
                                   onError:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED message:error.localizedDescription];
         }];
    }
    
    return shouldPerformSegue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//Pop to SignIn view controller
- (IBAction)signInButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
