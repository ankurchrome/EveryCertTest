//
//  FormsListViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 06/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormsListViewController.h"
#import "CertificateViewController.h"
#import "CertificateHandler.h"
#import "FormHandler.h"

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *_allFormsList;
}
@end

@implementation FormsListViewController

static NSString *const FormsListCellIdentifier = @"customCell";

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FormHandler *formHandler = [FormHandler new];

    //TODO: permissions will come from company_user table if no then 0 will be default
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
    //Instantiate CertificateViewController object from Storyboard
    UIStoryboard *mainStoryBoard = nil;
    CertificateViewController *certificateVC = nil;
    
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    certificateVC  = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CertificateViewController"];

    //Create a new certificate with selected form
    NSInteger           certRowId = 0;
    FormModel          *formModel = nil;
    CertificateModel   *newCertificate = nil;
    CertificateHandler *certHandler = nil;
    
    formModel = _allFormsList[indexPath.row];
    
    newCertificate = [CertificateModel new];
    newCertificate.formId = formModel.formId;
    
    certHandler = [CertificateHandler new];
    
    certRowId   = [certHandler insertCertificate:newCertificate];
    
    if (certRowId > 0)
    {
        newCertificate.certIdApp = certRowId;
        [certificateVC initializeWithCertificate:newCertificate];
        [self.navigationController pushViewController:certificateVC animated:YES];
    }
}

@end
