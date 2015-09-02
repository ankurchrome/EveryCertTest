//
//  ExistingCertificateViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ExistingCertificateViewController.h"
#import "UIView+Extension.h"
#import "MenuViewController.h"
#import "CertificateHandler.h"
#import "CertificateModel.h"
#import "FormHandler.h"
#import "FormModel.h"
#import "TextLabelElementCell.h"
#import <MessageUI/MessageUI.h>

#define IPHONE_WIDTH_PORTRAIT       300
#define IPHONE_WIDTH_LANDSCAPE      300

@interface ExistingCertificateViewController ()<UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
    __weak IBOutlet UITableView *_certificateTableView;
    __weak IBOutlet UIView *_backgroundView;
    __weak IBOutlet UIWebView *_webView;
    NSArray *_existingCertsList;
    CertificateHandler *_certHandler;

    float _deviceHeight;
    float _deviceWidth;
    BOOL  _certificateTableViewShow;
    BOOL  _hidePannel;
    MFMailComposeViewController  *_mailComposeVC;
}
@end

NSString *const MenuOptionImageNamed  = @"MenuOption.png";
NSString *const HomeBarButtonTitle    = @"Home";

@implementation ExistingCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationBarButtonItem];
    [self setCertificateTableViewFrame];
    
    //******** Send Notification When Device Orientation Changed
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChanged:) name: UIDeviceOrientationDidChangeNotification object: nil];
    _certHandler = [CertificateHandler new];
    _existingCertsList = [_certHandler getAllExistingCertificatesOfCompany:0];
    
    // Register TextLabel Nib
    [_certificateTableView registerNib:[UINib nibWithNibName:@"TextLabelElementCell" bundle:nil] forCellReuseIdentifier:TextLabelReuseIdentifier];
    
    // Drop Shadow on Table View
    _certificateTableView.clipsToBounds = NO;
    _certificateTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _certificateTableView.layer.shadowOffset = CGSizeMake(0,5);
    _certificateTableView.layer.shadowOpacity = 0.5;
    
    if(iPAD)
    {
        _certificateTableView.hidden = NO;
    
    }
    
    _hidePannel = YES;
    _certificateTableView.estimatedRowHeight =100.0;
    _certificateTableView.rowHeight = UITableViewAutomaticDimension;
}

// This Method Select the Initial Row of the Section Table as Default
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Check Weather the Array Count is Not Zero
    if(_existingCertsList.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_certificateTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];                       // Set Initial Row Selected
        [self tableView:_certificateTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _certificateTableView.hidden = NO;
}

#pragma mark - Private Method

// Add Navigation Bar Item According to the Current Device being used
- (void)addNavigationBarButtonItem
{
    if(iPHONE)  // If Device is iPhone
    {
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithTitle:HomeBarButtonTitle
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(onClickHomeButton:)];
        homeBarButton.tintColor        = [UIColor whiteColor];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithImage:
                                          [UIImage imageNamed:MenuOptionImageNamed] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButtonClick:)];
        _certificateTableViewShow       = NO;
        menuBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItems = @[menuBarButton, homeBarButton];
    }
    
    else if (iPAD)  // If Device is iPad
    {
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithTitle:HomeBarButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(onClickHomeButton:)];
        homeBarButton.tintColor        = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = homeBarButton;
    }
}

// Set table view frame from the current Device being used
- (void)setCertificateTableViewFrame
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        [_certificateTableView setFrameWidth:IPHONE_WIDTH_PORTRAIT];
        _certificateTableView.frame = CGRectMake(-(CGRectGetMaxX(_certificateTableView.frame)), 0,IPHONE_WIDTH_PORTRAIT, self.view.frame.size.height);
        _deviceWidth  = self.view.frame.size.width;
        _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 22;
    }
    else if(orientation == UIDeviceOrientationLandscapeLeft ||
            orientation == UIDeviceOrientationLandscapeRight)
    {
        _deviceWidth  = self.view.frame.size.width;
        _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
        
        [_certificateTableView setFrameWidth:IPHONE_WIDTH_LANDSCAPE];
        _certificateTableView.frame = CGRectMake(-(CGRectGetMaxX(_certificateTableView.frame)), 0, IPHONE_WIDTH_LANDSCAPE, self.view.frame.size.width);
    }
    if (LOGS_ON) NSLog(@"certificateTableView Frame = %@", _certificateTableView);
}

// Call when Device Orientation is change at run time
- (void)viewWillTransitionToSize
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if((_certificateTableView.frame.origin.x > 0))
    {
        if ((orientation == UIDeviceOrientationPortrait ||
             orientation == UIDeviceOrientationPortraitUpsideDown)) {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
            _certificateTableView.frame = CGRectMake(_certificateTableView.frame.origin.x, 0, IPHONE_WIDTH_PORTRAIT, _deviceHeight);
        }
        else if((orientation == UIDeviceOrientationLandscapeLeft ||
                 orientation == UIDeviceOrientationLandscapeRight))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
            _certificateTableView.frame = CGRectMake(_certificateTableView.frame.origin.x, 0, IPHONE_WIDTH_LANDSCAPE, _deviceWidth);
        }
    }
    else
    {
        if ((orientation == UIDeviceOrientationPortrait ||
             orientation == UIDeviceOrientationPortraitUpsideDown)) {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+42;
            [_certificateTableView setFrameY:0];
            [_certificateTableView setFrameWidth:IPHONE_WIDTH_PORTRAIT];
            [_certificateTableView setFrameHeight:_deviceHeight];
        }
        else if((orientation == UIDeviceOrientationLandscapeLeft ||
                 orientation == UIDeviceOrientationLandscapeRight))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+32;
            [_certificateTableView setFrameY:0];
            [_certificateTableView setFrameWidth:IPHONE_WIDTH_LANDSCAPE];
            [_certificateTableView setFrameHeight:_deviceHeight];
        }
    }
}

#pragma mark- IBActions

- (IBAction)onClickEditToolBarButton:(id)sender {
}

- (IBAction)onClickEmailToolBarButton:(id)sender {
    NSArray *_toRecipients = nil;
    
    if (![MFMailComposeViewController canSendMail])
    {
       // [CommonUtils showAlertWithTitle:@"Error" message:@"Check your account in Setting"];
    }
    
    if ([CommonUtils isValidString:@"mayur.sardana@gmail.com"])
    {
        _toRecipients = @[@"Demo Recipients"];
    }
    
    _mailComposeVC = [MFMailComposeViewController new];
    [_mailComposeVC setToRecipients:_toRecipients];
    [_mailComposeVC setSubject: @"DemoSubject"];
    _mailComposeVC.mailComposeDelegate = self;
    
//    [_mailComposeVC addAttachmentData:self.documentData
//                             mimeType:@"application/pdf"
//                             fileName:[self.filePath lastPathComponent]];
    
    _mailComposeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:_mailComposeVC animated:YES completion:nil];
}

- (IBAction)swipeRightOnWebView:(id)sender
{
    if(!_certificateTableViewShow && ! iPAD)
    {
        [UIView animateWithDuration:.3 animations:^{
            [_certificateTableView setFrameX: 0];
            [_certificateTableView setFrameHeight:_deviceHeight];
        }];
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
}

- (IBAction)singleTapOnBackgroundView:(id)sender
{
    if(_certificateTableViewShow)
    {
        _certificateTableViewShow = NO;
        [UIView animateWithDuration:.3 animations:^{
            [_certificateTableView setFrameX: -(CGRectGetMaxX(_certificateTableView.frame))];
            [_certificateTableView setFrameHeight:_deviceHeight];
        } completion:^(BOOL finished) {
            _certificateTableViewShow = NO;
            _backgroundView.hidden    = YES;
        }];
    }
}

#pragma mark - Selector

// When user Click on Menu Bar Button , the Tbale view move left - right
- (void)onMenuButtonClick:(id)sender
{
    if(!_certificateTableViewShow) {
        [UIView animateWithDuration:.3 animations:^{
            [_certificateTableView setFrameX: 0];
            [_certificateTableView setFrameHeight:_deviceHeight];
        }];
        
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
    else {
        [UIView animateWithDuration:.3 animations:^{
            [_certificateTableView setFrameX: -(CGRectGetMaxX(_certificateTableView.frame))];
            [_certificateTableView setFrameHeight:_deviceHeight];
        }];
        _certificateTableViewShow = NO;
        _backgroundView.hidden    = YES;
    }
}

// Control will navigate to MenuOption Screen
- (void)onClickHomeButton:(id)sender
{
    for(UIViewController *viewController in self.navigationController.viewControllers)
    {
        if([viewController isKindOfClass:[MenuViewController class]])
        {
            _certificateTableView.hidden = YES;
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

// Call when Device Orientation is changed
- (void)deviceOrientationDidChanged:(id)sender
{
    if(iPHONE)
    {
        [self viewWillTransitionToSize];
    }
}

#pragma mark - UIGestureRecognizerDelegate

// This Mehtod Allows Gesture to work also on Web View
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - MFMailComposeViewControllerDelegate

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _existingCertsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextLabelElementCell *cell = [tableView dequeueReusableCellWithIdentifier:TextLabelReuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [TextLabelElementCell new];
    }
    
    CertificateModel *certificateModel = _existingCertsList[indexPath.row];
    cell = [cell initWithCertificateModel:certificateModel];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateModel *certificateModel = _existingCertsList[indexPath.row];
    NSString *formName = certificateModel.name;
    FormHandler *formHandler = [FormHandler new];
    FormModel *formModel = nil;
    if (LOGS_ON) NSLog(@"%@", formModel.backgroundLayout);
    NSURL *url = [NSURL URLWithString:formModel.backgroundLayout];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
    
    if(!_hidePannel && iPHONE)
    {
        [UIView animateWithDuration:.3 animations:^{
            [_certificateTableView setFrameX: -(CGRectGetMaxX(_certificateTableView.frame))];
            [_certificateTableView setFrameHeight:_deviceHeight];
        } completion:^(BOOL finished) {
            _certificateTableViewShow = NO;
            _backgroundView.hidden    = YES;
        }];
    }
    else
    {
        _hidePannel = NO;
    }
}

#pragma mark - WebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    FUNCTION_START;
    
    FUNCTION_END;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    FUNCTION_START;
    
    FUNCTION_END;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    FUNCTION_START;
    
    if (LOGS_ON) NSLog(@"Error : %@ ", error.localizedDescription);
    
    FUNCTION_END;
}

@end
