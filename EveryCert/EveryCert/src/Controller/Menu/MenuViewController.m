//
//  MenuViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingViewController.h"
#import "FormsListViewController.h"
#import "ExistingCertificateViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_menuTableView;
    NSArray                     *_menuOptionList;
}
@end

static NSString *MenuOptionCellIdentifier       = @"MenuOptionCell";

NSString *const MenuOptionNewCertificate        = @"Create New Certificate";
NSString *const MenuOptionExistingCertificate   = @"Existing Certificate";
NSString *const MenuOptionSetting               = @"Setting";

@implementation MenuViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _menuOptionList = @[MenuOptionNewCertificate, MenuOptionExistingCertificate, MenuOptionSetting];
}

#pragma mark - IBActions

- (IBAction)onClickLogoutButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuOptionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuOptionCellIdentifier];
    cell.textLabel.text = _menuOptionList[indexPath.row];

    if(!cell) {
        cell = [UITableViewCell new];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];    
    
    if([_menuOptionList[indexPath.row] isEqualToString: MenuOptionNewCertificate])
    {
        FormsListViewController *formList = [storyBoard instantiateViewControllerWithIdentifier:@"FormList"];
        [self.navigationController pushViewController:formList animated:YES];
    }
    else if([_menuOptionList[indexPath.row] isEqualToString: MenuOptionExistingCertificate])
    {
        ExistingCertificateViewController *existingCertificate = [storyBoard instantiateViewControllerWithIdentifier:@"ExistingCertificate"];
        [self.navigationController pushViewController:existingCertificate animated:YES];
    }
    else if([_menuOptionList[indexPath.row] isEqualToString: MenuOptionSetting])
    {
        SettingViewController *setting = [storyBoard instantiateViewControllerWithIdentifier:@"Setting"];
        [self.navigationController pushViewController:setting animated:YES];
    }
}

@end
