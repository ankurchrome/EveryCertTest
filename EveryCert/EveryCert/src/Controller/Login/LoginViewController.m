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

@interface LoginViewController ()
{
    NSArray *_loginElements;
    IBOutlet ElementTableView *_loginElementTableView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ElementHandler *elementHandler = [ElementHandler new];
    [elementHandler.database open];
    
    _loginElements = [elementHandler getLoginElements];
    [elementHandler.database close];
    
    [_loginElementTableView reloadWithElements:_loginElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    //TODO:
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    // Change the color of Navigation Bar's Title Color on view Appear
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

#pragma mark - IBActions

- (IBAction)onClickForgetPasswordButton:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot password"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
    }];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Reset your password" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Code for Handling the AlertButton
        
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
