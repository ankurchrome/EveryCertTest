//
//  CertificatePreviewViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 27/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CertificatePreviewViewController.h"
#import <MessageUI/MessageUI.h>
#import "CertViewController.h"
#import "CertificateModel.h"
#import "CertificateHandler.h"
#import "MenuViewController.h"
#import "ElementModel.h"

@interface CertificatePreviewViewController ()<UIWebViewDelegate, MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIWebView   *_webView;
    MFMailComposeViewController  *_mailComposeVC;
    
    CertificateModel *_certificate;
}
@end

@implementation CertificatePreviewViewController

// Initialize the cell with the given certificate and show its pdf. Also allow the user to edit, delete and share the certificate.
- (void)initializeWithCertificate:(CertificateModel *)certificate
{
    _certificate = certificate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load the certificate pdf
    NSURL *url = [NSURL fileURLWithPath:[_certificate pdfPath]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

// Pop the View Controller to the MenuVC
- (IBAction)onClickHomeButton:(id)sender
{
    if (APP_DELEGATE.homeVC)
    {
        [self.navigationController popToViewController:APP_DELEGATE.homeVC animated:YES];
    }
}

// Show the CertViewController to edit the given certificate
- (IBAction)editButtonTapped:(id)sender
{
    CertViewController *certificateVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificateVC"];
    
    [certificateVC initializeWithCertificate:_certificate];
    
    [self.navigationController pushViewController:certificateVC animated:YES];
}

// Delete the selected certificate after the user confirmation
- (IBAction)deleteButtonTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE_WARNING message:ALERT_MESSAGE_DELETE preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:ALERT_ACTION_TITLE_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    CertificateHandler *certHandler = [CertificateHandler new];
                                    
                                    NSDictionary *columnInfo = @{
                                                                 Archive: @(true),
                                                                 ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                                                 IsDirty: @(true)
                                                                 };
                                    
                                    [certHandler updateInfo:columnInfo recordIdApp:_certificate.certIdApp];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:ALERT_ACTION_TITLE_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// Send the certificate's pdf through email
- (IBAction)emailButtonTapped:(id)sender
{
    //** If CurrrentDevice is not able to send Email then Show Alert
    if (![MFMailComposeViewController canSendMail])
    {
        [CommonUtils showAlertWithTitle:ALERT_TITLE_ERROR
                                message:ALERT_MESSAGE_EMAIL_NOT_CONFIGURED];
        return;
    }
    
    //** Extract the Subject String from Customer Address and Certificate Name Combination
    NSString *const customerAddressLine1 = @"customer_address_line_1";
    NSString *const customerAddressLine2 = @"customer_address_line_2";
    NSString *const customerAddressLine3 = @"customer_address_line_3";
    NSString *const customerAddressLine4 = @"customer_address_line_4";
    
    NSArray *fieldNameArray = @[
                                customerAddressLine1,
                                customerAddressLine2,
                                customerAddressLine3,
                                customerAddressLine4
                                ];
    
    NSMutableString *subjectString = [NSMutableString new];
    
    for(NSString *fieldName in fieldNameArray)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.fieldName CONTAINS %@", fieldName];
        ElementModel *filteredModel = [[APP_DELEGATE.certificateVC.formElements filteredArrayUsingPredicate:predicate] firstObject];
        
        
        if([CommonUtils isValidString:filteredModel.fieldName])
        {
            [subjectString appendString: filteredModel.dataValue];
            [subjectString appendString: @" "];
        }
    }
    [subjectString appendString: _certificate.name];
    
    NSData *certPdfData = [NSData dataWithContentsOfFile:[_certificate pdfPath]];
    
    _mailComposeVC = [MFMailComposeViewController new];
    [_mailComposeVC setSubject:subjectString];
    
    [_mailComposeVC setToRecipients:@[APP_DELEGATE.loggedUserEmail]];
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
