//
//  FormsListViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 06/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormsListViewController.h"
#import "CertificateViewController.h"
#import "FormHandler.h"

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *_allFormsList;
}
@end

@implementation FormsListViewController

static NSString *const FormsListCellIdentifier = @"FormTypeCellIdentifier";

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FormHandler *formHandler = [FormHandler new];
    _allFormsList = [formHandler getAllFormsWithPermissions:APP_DELEGATE.loggedUserPermissionGroup];
}

#pragma mark - IBActions

- (IBAction)onClickHomeBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allFormsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FormsListCellIdentifier];
    
    if(!cell)
    {
        cell = [UITableViewCell new];
    }
    
    FormModel *formModel = _allFormsList[indexPath.row];
    
    cell.textLabel.text = formModel.title;
    
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormModel *formModel = _allFormsList[indexPath.row];
    
    //Instantiate CertificateViewController object from Storyboard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CertificateViewController *certificateVC  = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CertificateViewController"];

    [certificateVC initializeWithForm:formModel];
    [self.navigationController pushViewController:certificateVC animated:YES];
}

@end
