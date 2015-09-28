//
//  CertificatePreviewViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 27/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CertificatePreviewViewController.h"
#import <MessageUI/MessageUI.h>
#import "CertificateModel.h"

@interface CertificatePreviewViewController ()<UIWebViewDelegate, MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIWebView   *_webView;
    
    MFMailComposeViewController  *_mailComposeVC;

    CertificateModel *_certificate;
}
@end

@implementation CertificatePreviewViewController

// Initialize with given existing certificate
- (void)initializeWithCertificate:(CertificateModel *)certificate
{
    _certificate = certificate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[_certificate pdfPath]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)emailButtonTapped:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        [CommonUtils showAlertWithTitle:@"Error" message:@"No account configured, please check your setting"];
        return;
    }
    
    NSString *subject = nil;
    NSData *certPdfData = [NSData dataWithContentsOfFile:[_certificate pdfPath]];
    
    _mailComposeVC = [MFMailComposeViewController new];
    [_mailComposeVC setSubject:subject];
    _mailComposeVC.mailComposeDelegate = self;
    
    [_mailComposeVC addAttachmentData:certPdfData
                             mimeType:@"application/pdf"
                             fileName:[_certificate pdfPath]];
    
    _mailComposeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:_mailComposeVC animated:YES completion:nil];
}


#pragma mark - WebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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
