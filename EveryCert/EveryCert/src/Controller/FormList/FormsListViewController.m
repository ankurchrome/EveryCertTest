//
//  FormsListViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 06/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormsListViewController.h"
#import "CertificateViewController.h"
#import "FormTypeTableViewCell.h"
#import "FormHandler.h"

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_formListTableView;
    
    NSArray *_allFormsList;
}
@end

@implementation FormsListViewController

static NSString *const FormsListCellIdentifier = @"FormTypeCellIdentifier";

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BG_COLOR;
    
    _formListTableView.estimatedRowHeight = 44.0;
    _formListTableView.rowHeight = UITableViewAutomaticDimension;

    FormHandler *formHandler = [FormHandler new];
    _allFormsList = [formHandler getAllFormsWithPermissions:APP_DELEGATE.loggedUserPermissionGroup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_formListTableView reloadData];
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
    FormTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FormsListCellIdentifier];
    
    FormModel *formModel = _allFormsList[indexPath.row];
    
    cell.titleLabel.text = formModel.title;
    cell.statusLabel.hidden = !formModel.status;//hide status label if form is saved
    cell.downloadImageView.hidden = formModel.status;//show download icon if form is not saved
    
    if (formModel.status)
    {
        cell.statusLabel.text = @"installed";
    }
    
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
