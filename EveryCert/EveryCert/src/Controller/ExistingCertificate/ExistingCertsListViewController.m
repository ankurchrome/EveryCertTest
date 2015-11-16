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
    
    _existingCertsTableView.estimatedRowHeight = 44.0;
    _existingCertsTableView.rowHeight = UITableViewAutomaticDimension;
    
    //** Shadow with Corner Radius on Login Table View
    _existingCertsTableView.superview.clipsToBounds = NO;
    _existingCertsTableView.superview.layer.masksToBounds = NO;
    _existingCertsTableView.superview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _existingCertsTableView.superview.layer.shadowOffset = CGSizeMake(0,5);
    _existingCertsTableView.superview.layer.shadowOpacity = 0.5;
    
    _existingCertsTableView.backgroundColor = APP_BG_COLOR;
    self.view.backgroundColor = APP_BG_COLOR;
    _certHandler = [CertificateHandler new];
    _existingCertsList = [_certHandler getAllExistingCertificatesOfCompany:APP_DELEGATE.loggedUserCompanyId];
}

- (void)viewWillAppear:(BOOL)animated
{
    _existingCertsList = [_certHandler getAllExistingCertificatesOfCompany:APP_DELEGATE.loggedUserCompanyId];
    [_existingCertsTableView reloadData];
}

#pragma mark- IBActions

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"CertPreviewVC"])
    {
        // If selected certificate is not issued then show it with CertViewController manually and stop the segue to be triggered
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

@end