//
//  ExistingCertificateViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ExistingCertificateViewController.h"
#import "UIView+Extension.h"
#import <MessageUI/MessageUI.h>
#import "ExistingCertificateTableViewCell.h"
#import "CertificateViewController.h"
#import "MenuViewController.h"

#import "CertificateHandler.h"

#define EXIST_CERTS_LIST_SHOW_HIDE_ANIMATION_DURATION 0.3f
#define EXIST_CERTS_LIST_BACKGROUND_ALPHA             0.6f

@interface ExistingCertificateViewController ()<UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
    __weak IBOutlet UITableView *_existingCertsTableView;
    __weak IBOutlet UIView      *_existingCertsView;
    __weak IBOutlet UIView      *_existingCertsFadedView;
    __weak IBOutlet UIWebView   *_webView;
    
    MFMailComposeViewController  *_mailComposeVC;
    
    CertificateHandler *_certHandler;
    CertificateModel   *_selectedCertificate;
    
    NSArray *_existingCertsList;
}
@end

@implementation ExistingCertificateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeUISetup];

    _certHandler = [CertificateHandler new];
    _existingCertsList = [_certHandler getAllExistingCertificatesOfCompany:0];
}

#pragma mark -

- (void)makeUISetup
{
    self.title = _selectedCertificate.name;
    self.view.backgroundColor = APP_BG_COLOR;
    
    _existingCertsTableView.backgroundColor = APP_BG_COLOR;
    _existingCertsTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    _existingCertsTableView.clipsToBounds = NO;
    _existingCertsTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _existingCertsTableView.layer.shadowOffset = CGSizeMake(0,5);
    _existingCertsTableView.layer.shadowOpacity = 0.5;
}

- (void)showExistingCertsListView
{
    [_existingCertsTableView setFrameX:-_existingCertsTableView.frameWidth];
    _existingCertsView.hidden = NO;
    
    [UIView animateWithDuration:EXIST_CERTS_LIST_SHOW_HIDE_ANIMATION_DURATION
                     animations:^
     {
         [_existingCertsTableView setFrameX:0];
         _existingCertsFadedView.alpha = EXIST_CERTS_LIST_BACKGROUND_ALPHA;
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void)hideExistingCertsListView
{
    [UIView animateWithDuration:EXIST_CERTS_LIST_SHOW_HIDE_ANIMATION_DURATION
                     animations:^
     {
         [_existingCertsTableView setFrameX:-_existingCertsTableView.frameWidth];
         _existingCertsFadedView.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         _existingCertsView.hidden = YES;
         [_existingCertsTableView setFrameX:0];
     }];
}

#pragma mark- IBActions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CertificateVC"])
    {
        CertificateViewController *certificateVC  = [segue destinationViewController];
        
        [certificateVC initializeWithCertificate:_selectedCertificate];
    }
}

- (IBAction)menuButtonTapped:(id)sender
{
    if(_existingCertsView.hidden)
    {
        [self showExistingCertsListView];
    }
    else
    {
        [self hideExistingCertsListView];
    }
}

- (IBAction)homeButtonTapped:(id)sender
{
    
}

- (IBAction)existingCertsFadedViewTapped:(id)sender
{
    [self hideExistingCertsListView];
}

- (IBAction)onSwipeWebView:(id)sender
{
    [self showExistingCertsListView];
}

- (IBAction)emailButtonTapped:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        [CommonUtils showAlertWithTitle:@"Error" message:@"No account configured, please check your setting"];
        return;
    }
    
    NSString *subject = nil;
    NSData *certPdfData = [NSData dataWithContentsOfFile:[_selectedCertificate pdfPath]];
    
    _mailComposeVC = [MFMailComposeViewController new];
    [_mailComposeVC setSubject:subject];
    _mailComposeVC.mailComposeDelegate = self;
    
    [_mailComposeVC addAttachmentData:certPdfData
                             mimeType:@"application/pdf"
                             fileName:[_selectedCertificate pdfPath]];
    
    _mailComposeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:_mailComposeVC animated:YES completion:nil];
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
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy hh:mm:ss";
    
    cell.nameLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:certificateModel.dateTimestamp]];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateModel *certificateModel = _existingCertsList[indexPath.row];
    _selectedCertificate = certificateModel;
    
    NSURL *url = [NSURL URLWithString:[_selectedCertificate pdfPath]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

    [_webView loadRequest:requestObj];
    
    [self hideExistingCertsListView];
}

#pragma mark - WebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (LOGS_ON) NSLog(@"Error : %@ ", error.localizedDescription);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *resultString = nil;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            resultString = @"Email cancelled.";
            break;
            
        case MFMailComposeResultFailed:
            resultString = @"Email send failed.";
            break;
            
        case MFMailComposeResultSaved:
            resultString = @"Email saved.";
            break;
            
        case MFMailComposeResultSent:
            resultString = @"Email sent.";
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
