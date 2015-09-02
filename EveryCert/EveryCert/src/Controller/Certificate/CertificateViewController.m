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
    __weak IBOutlet UIButton            *_nextToolBarButton;
    __weak IBOutlet UILabel             *_toolBarTitle;
    __weak IBOutlet UITableView         *_sectionTableView;
    __weak IBOutlet ElementTableView    *_elementTableView;
    __weak IBOutlet UIView              *_backgroundView;
    
    float _deviceHeight;
    float _deviceWidth;
    BOOL _certificateTableViewShow;
    
    FormSectionHandler *_sectionHandler;
    int _indexPathRow;
    BOOL _hidePannel;
    
    CertificateModel *_certificate;
    NSArray *_formSections;
    NSArray *_formElements;
    NSArray *_currentSectionElements;
    
    NSInteger _currentSectionIndex;
}
@end

NSString *const MenuOptionImageName = @"MenuOption.png";
NSString *const HomeBarButton       = @"Home";

@implementation CertificateViewController

// Returns an initialized CertificateViewController with CertificateModel object
- (id)initWithCertificate:(CertificateModel *)certificate
{
    self = [super init];
    
    if (self)
    {
        _certificate = certificate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ElementHandler *elementHandler = [ElementHandler new];
    _formElements = [elementHandler getAllElementsOfForm:_certificate.formId];
    
    FormSectionHandler *sectionHandler = [FormSectionHandler new];
    _formSections = [sectionHandler getAllSectionsOfForm:_certificate.formId];

    _currentSectionIndex = 0;
    [self showElementsForSectionIndex:_currentSectionIndex];

    
    
    [self addNavigationBarButtonItem];
    [self setCertificateTableViewFrame];
    
    _hidePannel = YES;
    
    //******** Send Notification When Device Orientation Changed
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChanged:) name: UIDeviceOrientationDidChangeNotification object: nil];

    [_sectionTableView registerNib:[UINib nibWithNibName:@"TextLabelElementCell" bundle:nil]
            forCellReuseIdentifier:TextLabelReuseIdentifier];

    // Drop Shadow on Table View
    _sectionTableView.clipsToBounds = NO;
    _sectionTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _sectionTableView.layer.shadowOffset = CGSizeMake(0,5);
    _sectionTableView.layer.shadowOpacity = 0.5;
}

- (void)showElementsForSectionIndex:(NSInteger)sectionIndex
{
    FormSectionModel *formSection = nil;
    NSPredicate *predicate = nil;
    
    if (_formSections && sectionIndex < _formSections.count)
    {
        formSection = [_formSections objectAtIndex:sectionIndex];
    
        predicate = [NSPredicate predicateWithFormat:@"section_id = %ld", formSection.sectionId];
        
        _currentSectionElements = [_formElements filteredArrayUsingPredicate:predicate];
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:sectionIndex inSection:0];
        [_sectionTableView selectRowAtIndexPath:sectionIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [_elementTableView reloadWithElements:_currentSectionElements];
    }
}

// This Method Select the Initial Row of the Section Table as Default
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Check Weather the Array Count is Not Zero
    if(_formSections.count > 0)
    {
        FormSectionModel *sectionModel = _formSections[0];
        _toolBarTitle.text = sectionModel.title;                    // Set Label Title
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_sectionTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];                       // Set Initial Row Selected
        [self tableView:_sectionTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _sectionTableView.hidden = NO;
}

#pragma mark - Private Method

// Add Navigation Bar Item According to the Current Device being used
- (void)addNavigationBarButtonItem
{
    if(iPHONE)  // If Device is iPhone
    {
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithTitle:HomeBarButton
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(onClickHomeButton:)];
        homeBarButton.tintColor        = [UIColor whiteColor];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithImage:
                                          [UIImage imageNamed:MenuOptionImageName] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButtonClick:)];
        _certificateTableViewShow       = NO;
        menuBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItems = @[menuBarButton, homeBarButton];
    }
    
    else if (iPAD)  // If Device is iPad
    {
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithTitle:HomeBarButton style:UIBarButtonItemStylePlain target:self action:@selector(onClickHomeButton:)];
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
}

// Call when Device Orientation is change at run time
- (void)viewWillTransitionToSize
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if((_sectionTableView.frame.origin.x > 0))
    {
        if ((orientation == UIDeviceOrientationPortrait ||
             orientation == UIDeviceOrientationPortraitUpsideDown)) {
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
             orientation == UIDeviceOrientationPortraitUpsideDown)) {
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

#pragma mark- IBActions

- (IBAction)onClickBackToolBarButton:(id)sender
{
    if(_indexPathRow > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:--_indexPathRow inSection:0];
        [_sectionTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        _hidePannel = YES;
        [self tableView:_sectionTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (IBAction)onClickNextToolBarButton:(id)sender
{
    if(_indexPathRow < _formSections.count-1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:++_indexPathRow inSection:0];
        [_sectionTableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
        _hidePannel = YES;
        [self tableView:_sectionTableView didSelectRowAtIndexPath:indexPath];
    }
}

//Work when Click Single Tap on Background View
- (IBAction)singleTapOnBackgroundView:(id)sender
{
    if(_certificateTableViewShow)
    {
        _certificateTableViewShow = NO;
        [UIView animateWithDuration:.3 animations:^{
            [_sectionTableView setFrameX: -(CGRectGetMaxX(_sectionTableView.frame))];
            [_sectionTableView setFrameHeight:_deviceHeight];

        } completion:^(BOOL finished) {
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
        [UIView animateWithDuration:.3 animations:^{
            [_sectionTableView setFrameX: 0];
            [_sectionTableView setFrameHeight:_deviceHeight];
        }];
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
}

#pragma mark - Selectors

// When user Click on Menu Bar Button , the Tbale view move left - right
- (void)onMenuButtonClick:(id)sender
{
    if(!_certificateTableViewShow) {
        [UIView animateWithDuration:.3 animations:^{
            [_sectionTableView setFrameX: 0];
            [_sectionTableView setFrameHeight:_deviceHeight];
        }];
        
        _certificateTableViewShow = YES;
        _backgroundView.hidden    = NO;
    }
    else {
        [UIView animateWithDuration:.3 animations:^{
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

// Call when Device Orientation is changed
- (void)deviceOrientationDidChanged:(id)sender
{
    if(iPHONE)
    {
        [self viewWillTransitionToSize];
    }
}

#pragma mark - UITableViewDataSource

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_elementTableView reloadWithElements:_currentSectionElements];
    _indexPathRow = (int)indexPath.row;
    
    ElementHandler *elementHandler = [ElementHandler new];
    FormSectionModel *sectionModel = _formSections[indexPath.row];
    _toolBarTitle.text = sectionModel.title;
    [_elementTableView reloadData];
    
    if(!_hidePannel && iPHONE)
    {
        [UIView animateWithDuration:.3 animations:^{
            [_sectionTableView setFrameX: -(CGRectGetMaxX(_sectionTableView.frame))];
            [_sectionTableView setFrameHeight:_deviceHeight];
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

@end
