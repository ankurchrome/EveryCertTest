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

@interface RegistrationViewController ()
{
    IBOutlet ElementTableView *_signupElementTableView;

    NSArray *_signupElements;
}
@end

@implementation RegistrationViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ElementHandler *elementHandler = [ElementHandler new];
    _signupElements = [elementHandler getSignUpElements];
    
    [_signupElementTableView reloadWithElements:_signupElements];
}

#pragma mark - IBActions

- (IBAction)onClickSignInButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
