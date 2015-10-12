//
//  ExistingCertsListViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 27/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ExistingCertsListViewController.h"
#import "ExistingCertificateTableViewCell.h"
#import "CertViewController.h"
#import "CertificatePreviewViewController.h"
#import "CertificateHandler.h"

@interface ExistingCertsListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_existingCertsTableView;
    
    CertificateHandler *_certHandler;
    CertificateModel   *_selectedCertificate;
    NSArray *_existingCertsList;
}
@end

@implementation ExistingCertsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _certHandler = [CertificateHandler new];
    _existingCertsList = [_certHandler getAllExistingCertificatesOfCompany:APP_DELEGATE.loggedUserCompanyId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- IBActions

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"CertPreviewVC"])
    {
        if ([sender isKindOfClass:[ExistingCertificateTableViewCell class]])
        {
            CertificateModel *certificateModel = ((ExistingCertificateTableViewCell *)sender).certificate;
            
             if (!certificateModel.issuedApp)
             {
                 CertViewController *certificateVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificateVC"];
                 
                 [certificateVC initializeWithCertificate:certificateModel];
                 
                 [self.navigationController pushViewController:certificateVC animated:YES];
                 
                 return NO;
             }
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CertPreviewVC"])
    {
        if ([sender isKindOfClass:[ExistingCertificateTableViewCell class]])
        {
            CertificateModel *certificateModel = ((ExistingCertificateTableViewCell *)sender).certificate;
            
                CertificatePreviewViewController *certPreviewVC = segue.destinationViewController;
                
                [certPreviewVC initializeWithCertificate:certificateModel];
        }
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _existingCertsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExistingCertificateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExistingCertCellReuseIdentifier forIndexPath:indexPath];
    
    CertificateModel *certificateModel = _existingCertsList[indexPath.row];

    [cell initializeWithCertificate:certificateModel];
    
    return cell;
}

#pragma mark - UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end