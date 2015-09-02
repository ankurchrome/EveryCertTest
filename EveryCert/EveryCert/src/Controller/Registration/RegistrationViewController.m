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

//#import "TextFieldElementCell.h"

@interface RegistrationViewController ()
{
    IBOutlet ElementTableView *_signupElementTableView;
    __weak IBOutlet UILabel *_termsAndServicesLabel;

    NSArray *_signupElements;
}
@end

@implementation RegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ElementHandler *elementHandler = [ElementHandler new];
    [elementHandler.database open];
    _signupElements = [elementHandler getSignUpElements];
    [elementHandler.database close];
    
    [_signupElementTableView reloadWithElements:_signupElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - IBActions

- (IBAction)onClickSignInButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
