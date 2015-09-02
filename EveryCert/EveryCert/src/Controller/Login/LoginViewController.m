//
//  LoginViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "TextFieldElementCell.h"

@interface LoginViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_elementsArray;
    __weak IBOutlet UITableView *_loginTableView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _elementsArray = @[@"Email Address", @"Password"];
    [_loginTableView registerNib:[UINib nibWithNibName:@"TextFieldElementCell" bundle:nil] forCellReuseIdentifier:TextFieldReuseIdentifier];
    _loginTableView.estimatedRowHeight = 70.0;
    _loginTableView.rowHeight = UITableViewAutomaticDimension;
    _loginTableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    // Change the color of Navigation Bar's Title Color on view Appear
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

#pragma mark - IBActions

- (IBAction)onClickForgetPasswordButton:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot password" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
    }];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Reset your password" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Code for Handling the AlertButton
        
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _elementsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldElementCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldReuseIdentifier];
    if(!cell)
    {
        cell = [TextFieldElementCell new];
    }
    [cell initWithData:_elementsArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frameHeight / _elementsArray.count;
}

@end
