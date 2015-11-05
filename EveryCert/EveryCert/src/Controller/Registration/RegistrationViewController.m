//
//  RegistrationViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ElementTableView.h"
#import "ElementHandler.h"

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

//Pop to SignIn view controller
- (IBAction)signInButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
