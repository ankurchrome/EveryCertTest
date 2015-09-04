//
//  CertificateViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CertificateViewController.h"
#import "MenuViewController.h"
#import "UIView+Extension.h"
#import "ElementTableView.h"
#import "TextFieldElementCell.h"
#import "FormSectionHandler.h"
#import "TextLabelElementCell.h"
#import "ElementHandler.h"

#define IPHONE_WIDTH_PORTRAIT  300
#define IPHONE_WIDTH_LANDSCAPE 300

@interface CertificateViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UIButton    *_nextToolBarButton;
    __weak IBOutlet UILabel     *_toolBarTitle;
    __weak IBOutlet UITableView *_sectionTableView;
    __weak IBOutlet UIView      *_backgroundView;

    __weak IBOutlet ElementTableView  *_elementTableView;
    
    float _deviceHeight;
    float _deviceWidth;
    BOOL  _certificateTableViewShow;
    
    int  _indexPathRow;
    BOOL _hidePannel;
    
    CertificateModel *_certificate;
    NSArray  *_formSections;
    NSArray  *_formElements;
    NSArray  *_currentSectionElements;
    NSInteger _currentSectionIndex;
}
@end

@implementation CertificateViewController

#pragma mark - Initialization Methods

// Initialize CertificateViewController with CertificateModel object
- (void)initializeWithCertificate:(CertificateModel *)certificate
{
    _certificate = certificate;
}

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeUISetup];
    
    //Load form's sections and their elements
    ElementHandler *elementHandler = [ElementHandler new];
    _formElements = [elementHandler getAllElementsOfForm:_certificate.formId];
    
    FormSectionHandler *sectionHandler = [FormSectionHandler new];
    _formSections = [sectionHandler getAllSectionsOfForm:_certificate.formId];

    //Initially show first section's elements
    [self showElementsForSectionIndex:0];
}

//// This Method Select the Initial Row of the Section Table as Default
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    // Check Weather the Array Count is Not Zero
//    if(_formSections.count > 0)
//    {
//        FormSectionModel *sectionModel = _formSections[0];
//        _toolBarTitle.text = sectionModel.title;                    // Set Label Title
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_sectionTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];                       // Set Initial Row Selected
//        [self tableView:_sectionTableView didSelectRowAtIndexPath:indexPath];
//    }
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    _sectionTableView.hidden = NO;
//}

#pragma mark -

- (void)makeUISetup
{
    // Add Navigation Bar Item According to the Current Device being used
    UIBarButtonItem *homeBarButton = nil;
    UIBarButtonItem *menuBarButton = nil;
    UIImage *menuImage = nil;

    homeBarButton = [[UIBarButtonItem alloc]initWithTitle:HomeBarButtonTitle
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(onClickHomeButton:)];
    homeBarButton.tintColor = [UIColor whiteColor];

    if (iPHONE)
    {
        menuImage     = [UIImage imageNamed:@"MenuOption"];
        menuBarButton = [[UIBarButtonItem alloc]initWithImage:menuImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(onMenuButtonClick:)];
        menuBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItems = @[menuBarButton, homeBarButton];
        _certificateTableViewShow = NO;
    }
    else if (iPAD)
    {
        self.navigationItem.leftBarButtonItem = homeBarButton;
    }

    // Set table view frame from the current Device being used
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [_sectionTableView setFrameWidth:IPHONE_WIDTH_PORTRAIT];
        _sectionTableView.frame = CGRectMake(-(CGRectGetMaxX(_sectionTableView.frame)), 0,IPHONE_WIDTH_PORTRAIT, self.view.frame.size.height);
        _deviceWidth  = self.view.frame.size.width;
        _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 22;
    }
    else if(orientation == UIDeviceOrientationLandscapeLeft ||
            orientation == UIDeviceOrientationLandscapeRight)
    {
        _deviceWidth  = self.view.frame.size.width;
        _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
        
        [_sectionTableView setFrameWidth:IPHONE_WIDTH_LANDSCAPE];
        _sectionTableView.frame = CGRectMake(-(CGRectGetMaxX(_sectionTableView.frame)), 0, IPHONE_WIDTH_LANDSCAPE, self.view.frame.size.width);
    }
    
    _hidePannel = YES;
    
    // Send Notification When Device Orientation Changed
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    //Setup section table view
    UINib *sectionCellNib = [UINib nibWithNibName:@"TextLabelElementCell" bundle:nil];
    [_sectionTableView registerNib:sectionCellNib forCellReuseIdentifier:TextLabelReuseIdentifier];
    
    _sectionTableView.clipsToBounds = NO;
    _sectionTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _sectionTableView.layer.shadowOffset = CGSizeMake(0,5);
    _sectionTableView.layer.shadowOpacity = 0.5;
}

// Call when Device Orientation is change at run time
- (void)viewWillTransitionToSize
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if((_sectionTableView.frame.origin.x > 0))
    {
        if ((orientation == UIDeviceOrientationPortrait ||
             orientation == UIDeviceOrientationPortraitUpsideDown))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
            _sectionTableView.frame = CGRectMake(_sectionTableView.frame.origin.x, 0, IPHONE_WIDTH_PORTRAIT, _deviceHeight);
        }
        else if((orientation == UIDeviceOrientationLandscapeLeft ||
                 orientation == UIDeviceOrientationLandscapeRight))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
            _sectionTableView.frame = CGRectMake(_sectionTableView.frame.origin.x, 0, IPHONE_WIDTH_LANDSCAPE, _deviceWidth);
        }
    }
    else
    {
        if ((orientation == UIDeviceOrientationPortrait ||
             orientation == UIDeviceOrientationPortraitUpsideDown))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+42;
            [_sectionTableView setFrameY:0];
            [_sectionTableView setFrameWidth:IPHONE_WIDTH_PORTRAIT];
            [_sectionTableView setFrameHeight:_deviceHeight];
        }
        else if((orientation == UIDeviceOrientationLandscapeLeft ||
                 orientation == UIDeviceOrientationLandscapeRight))
        {
            _deviceWidth  = self.view.frame.size.width;
            _deviceHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+32;
            [_sectionTableView setFrameY:0];
            [_sectionTableView setFrameWidth:IPHONE_WIDTH_LANDSCAPE];
            [_sectionTableView setFrameHeight:_deviceHeight];
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

#pragma mark - IBActions & Event Methods

// When user Click on Menu Bar Button , the Tbale view move left - right
- (void)onMenuButtonClick:(id)sender
{
    if(!_certificateTableViewShow)
    {
        [UIView animateWithDuration:.3 animations:^
         {
             [_sectionTableView setFrameX: 0];
             [_sectionTableView setFrameHeight:_deviceHeight];
         }];
        
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^
         {
             [_sectionTableView setFrameX: -(CGRectGetMaxX(_sectionTableView.frame))];
             [_sectionTableView setFrameHeight:_deviceHeight];
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
            _sectionTableView.hidden = YES;
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

//Work when Click Single Tap on Background View
- (IBAction)singleTapOnBackgroundView:(id)sender
{
    if(_certificateTableViewShow)
    {
        _certificateTableViewShow = NO;
        [UIView animateWithDuration:.3 animations:^
         {
             [_sectionTableView setFrameX: -(CGRectGetMaxX(_sectionTableView.frame))];
             [_sectionTableView setFrameHeight:_deviceHeight];
         }
                         completion:^(BOOL finished)
         {
             _certificateTableViewShow = NO;
             _backgroundView.hidden    = YES;
         }];
    }
}

//Work when Click on BackGround View
- (IBAction)swipeRightOnBackgroundView:(id)sender
{
    if(!_certificateTableViewShow && ! iPAD)
    {
        [UIView animateWithDuration:.3 animations:^
         {
             [_sectionTableView setFrameX: 0];
             [_sectionTableView setFrameHeight:_deviceHeight];
         }];
        
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
}

- (IBAction)onClickBackToolBarButton:(id)sender
{
    if (--_currentSectionIndex < 0)
    {
        _currentSectionIndex = _formSections.count;
    }
    
    [self showElementsForSectionIndex:_currentSectionIndex];
}

- (IBAction)onClickNextToolBarButton:(id)sender
{
    if (++_currentSectionIndex >= _formSections.count)
    {
        _currentSectionIndex = 0;
    }
    
    [self showElementsForSectionIndex:_currentSectionIndex];
}

#pragma mark -

- (void)showElementsForSectionIndex:(NSInteger)sectionIndex
{
    FormSectionModel *formSection = nil;
    NSPredicate *predicate = nil;
    
    if (_formSections && sectionIndex < _formSections.count)
    {
        formSection = [_formSections objectAtIndex:sectionIndex];
        
        _toolBarTitle.text = formSection.title;
        
        predicate = [NSPredicate predicateWithFormat:@"sectionId = %ld", formSection.sectionId];
        
        _currentSectionElements = [_formElements filteredArrayUsingPredicate:predicate];
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:sectionIndex inSection:0];
        [_sectionTableView selectRowAtIndexPath:sectionIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [_elementTableView reloadWithElements:_currentSectionElements];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _formSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextLabelElementCell *cell = [tableView dequeueReusableCellWithIdentifier:TextLabelReuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [TextLabelElementCell new];
    }
    
    cell = [cell initWithSectionModel:_formSections[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showElementsForSectionIndex:indexPath.row];
    
    if(!_hidePannel && iPHONE)
    {
        [UIView animateWithDuration:.3 animations:^
        {
            [_sectionTableView setFrameX: -(CGRectGetMaxX(_sectionTableView.frame))];
            [_sectionTableView setFrameHeight:_deviceHeight];
        }
                         completion:^(BOOL finished)
        {
            _certificateTableViewShow = NO;
            _backgroundView.hidden    = YES;
        }];
    }
    else
    {
        _hidePannel = NO;
    }
}

@end
