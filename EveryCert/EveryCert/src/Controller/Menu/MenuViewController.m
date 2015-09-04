//
//  MenuViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "FormsListViewController.h"
#import "ExistingCertificateViewController.h"
#import "SettingViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_menuTableView;
    
    NSArray *_menuOptionList;
}
@end

static NSString *const MenuOptionCellIdentifier  = @"MenuOptionCell";

NSString *const MenuOptionRowNewCertificate      = @"Create New Certificate";
NSString *const MenuOptionRowExistingCertificate = @"Existing Certificate";
NSString *const MenuOptionRowSetting             = @"Setting";

@implementation MenuViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuOptionList = @[MenuOptionRowNewCertificate,
                        MenuOptionRowExistingCertificate,
                        MenuOptionRowSetting];
}

#pragma mark - IBActions

- (IBAction)onClickLogoutButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuOptionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuOptionCellIdentifier];
    
    cell.textLabel.text = _menuOptionList[indexPath.row];

    if(!cell)
    {
        cell = [UITableViewCell new];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *nextVC = nil;
    
    NSString     *selectedRow = _menuOptionList[indexPath.row];
    UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if([selectedRow isEqualToString:MenuOptionRowNewCertificate])
    {
        nextVC = [storyBoard instantiateViewControllerWithIdentifier:@"FormList"];
    }
    else if([selectedRow isEqualToString:MenuOptionRowNewCertificate])
    {
        nextVC = [storyBoard instantiateViewControllerWithIdentifier:@"ExistingCertificate"];
    }
    else if([selectedRow isEqualToString:MenuOptionRowNewCertificate])
    {
        nextVC = [storyBoard instantiateViewControllerWithIdentifier:@"Setting"];
    }
    
    if (nextVC)
    {
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

@end
