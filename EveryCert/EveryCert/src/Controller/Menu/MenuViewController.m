//
//  MenuViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "FormsListViewController.h"
#import "SettingViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_menuTableView;
    IBOutlet UILabel *_lastSyncLabel;
    
    NSArray *_menuOptionList;
}
@end

NSString *const MenuCellIdentifierNewCertificate      = @"MenuCellIdentifierNewCert";
NSString *const MenuCellIdentifierExistingCertificate = @"MenuCellIdentifierExistingCert";
NSString *const MenuCellIdentifierSetting             = @"MenuCellIdentifierSetting";

@implementation MenuViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = APP_BG_COLOR;
    APP_DELEGATE.homeVC = self;
    
    _menuOptionList = @[MenuCellIdentifierNewCertificate,
                        MenuCellIdentifierExistingCertificate,
                        MenuCellIdentifierSetting];
}

#pragma mark - IBActions

//Logout the logged in user and pop to SignIn screen
- (IBAction)onClickLogoutButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    APP_DELEGATE.homeVC = nil;
}

//Start the sync with server for all data
- (IBAction)backupDataButtonTapped:(id)sender
{
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuOptionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = _menuOptionList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

    if(!cell)
    {
        cell = [UITableViewCell new];
    }
    
    return cell;
}

@end
