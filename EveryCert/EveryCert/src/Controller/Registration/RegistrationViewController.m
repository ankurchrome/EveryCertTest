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

    //** Shadow with Corner Radius on Login Table View
    _signupElementTableView.superview.clipsToBounds = NO;
    _signupElementTableView.superview.layer.masksToBounds = NO;
    _signupElementTableView.superview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _signupElementTableView.superview.layer.shadowOffset = CGSizeMake(0,5);
    _signupElementTableView.superview.layer.shadowOpacity = 0.5;
    
    _signupElementTableView.layer.masksToBounds = YES;
    _signupElementTableView.layer.cornerRadius = 10.0f;
    
    ElementHandler *elementHandler = [ElementHandler new];
    _signupElements = [elementHandler getSignUpElements];
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frameWidth, CGRectGetMaxY(_contentView.frame));
    [_signupElementTableView removeObserver];
    [_signupElementTableView reloadWithElements:_signupElements];
}

#pragma mark - IBActions

//Pop to SignIn view controller
- (IBAction)signInButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
