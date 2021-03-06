//
//  MenuViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "FormsListViewController.h"
#import "SettingViewController.h"
#import "ECSyncManager.h"
#import "AFNetworking.h"
#import "DataBinaryHandler.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_menuTableView;
    IBOutlet UILabel *_lastSyncLabel;
    
    NSArray *_menuOptionList;
    
    ECSyncManager *_syncManager;
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
    
    //** Shadow with Corner Radius on Login Table View
    _menuTableView.superview.clipsToBounds = NO;
    _menuTableView.superview.layer.masksToBounds = NO;
    _menuTableView.superview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _menuTableView.superview.layer.shadowOffset = CGSizeMake(0,5);
    _menuTableView.superview.layer.shadowOpacity = 0.5;
    
    _menuTableView.layer.masksToBounds = YES;
    _menuTableView.layer.cornerRadius = 10.0f;
    
    _menuOptionList = @[MenuCellIdentifierNewCertificate,
                        MenuCellIdentifierExistingCertificate,
                        MenuCellIdentifierSetting];
    
    _syncManager = [ECSyncManager new];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isInitialLogin)
    {
        //Check for internet availability for login through server
        if (![[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED
                                    message:AlertMessageConnectionNotFound];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
        hud.labelText = HudTitleLoading;
        
        [_syncManager startCompleteSyncWithCompletion:^(BOOL success, NSError *error)
         {
             [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
             
             DataBinaryHandler *dataBinaryHandler = [DataBinaryHandler new];
             [dataBinaryHandler downloadAllDataBinary];
         }];
        
        self.isInitialLogin = NO;
    }
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
    //Check for internet availability for login through server
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED
                                message:AlertMessageConnectionNotFound];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    hud.labelText = HudTitleLoading;
    
    [_syncManager backupDataWithCompletion:^(BOOL success, NSError *error)
     {
         [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
         
         DataBinaryHandler *dataBinaryHandler = [DataBinaryHandler new];
         [dataBinaryHandler downloadAllDataBinary];
     }];
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
