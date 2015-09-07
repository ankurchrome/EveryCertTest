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

#import "FormModel.h"
#import "SubElementModel.h"
#import "FormSectionHandler.h"
#import "ElementHandler.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"
#import "CertificateHandler.h"

#import "TextFieldElementCell.h"
#import "TextLabelElementCell.h"

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
    
    BOOL _isExistingCertificate;
    
    CertificateModel *_certificate;
    NSArray  *_formSections;
    NSArray  *_formElements;
    NSArray  *_currentSectionElements;
    NSInteger _currentSectionIndex;
    
    DataHandler       *_dataHandler;
    DataBinaryHandler *_dataBinaryHandler;
}
@end

@implementation CertificateViewController

NSString *const FormSectionCellReuseIdentifier = @"FormSectionCellIdentifier";

#pragma mark - Initialization Methods

// Initialize CertificateViewController by creating a new certificate of given form type
- (void)initializeWithForm:(FormModel *)form
{
    //Create a new certificate with selected form
    CertificateModel *newCertificate = [CertificateModel new];
    newCertificate.formId = form.formId;
    
    CertificateHandler *certHandler = [CertificateHandler new];
    NSInteger certRowId = [certHandler insertCertificate:newCertificate];
    
    if (certRowId > 0)
    {
        newCertificate.certIdApp = certRowId;
        _certificate = newCertificate;
    }
}

// Initialize CertificateViewController with given existing certificate
- (void)initializeWithCertificate:(CertificateModel *)certificate
{
    _certificate = certificate;
    _isExistingCertificate = YES;
}

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeUISetup];
    
    //Load form's sections and their elements
    ElementHandler *elementHandler = [ElementHandler new];

    if (_isExistingCertificate)
    {
        _formElements = [elementHandler getAllElementsOfForm:_certificate.formId withDataOfCertificate:_certificate.certIdApp];
    }
    else
    {
        _formElements = [elementHandler getAllElementsOfForm:_certificate.formId];
    }
    
    FormSectionHandler *sectionHandler = [FormSectionHandler new];
    _formSections = [sectionHandler getAllSectionsOfForm:_certificate.formId];

    //Initially show first section's elements
    [self showElementsForSectionIndex:0];
}

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
    UINib *sectionCellNib = [UINib nibWithNibName:ElementCellNibNameTextLabel bundle:nil];
    [_sectionTableView registerNib:sectionCellNib forCellReuseIdentifier:ElementCellReuseIdentifierTextLabel];
    
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

#pragma mark - Functionality Methods

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

//Save the data for all given elements
- (void)saveAllElements:(NSArray *)elements
{
    for (ElementModel *elementModel in elements)
    {
        switch (elementModel.fieldType)
        {
            case ElementTypeTextField:
            case ElementTypeTextView:
            case ElementTypePickListOption:
            case ElementTypeRadioButton:
            case ElementTypeLookup:
            {
                [self saveElementData:elementModel];
            }
                break;
                
            case ElementTypeSubElement:
            {
                //Create JSON content for Sub element's content
                NSString *subElementContent = nil;
                NSString *subElementKey     = nil;
                NSData   *subElementData    = nil;
                
                NSMutableDictionary *subElementInfo = [NSMutableDictionary new];
                
                for (SubElementModel *subElementModel in elementModel.subElements)
                {
                    if (subElementModel.dataValue)
                    {
                        subElementKey = @(subElementModel.subElementId).stringValue;
                        [subElementInfo setObject:subElementModel.dataValue forKey:subElementKey];
                    }
                }
                
                if (subElementInfo.count <= 0)
                {
                    continue;
                }
                
                subElementData = [NSJSONSerialization dataWithJSONObject:subElementInfo options:0 error:nil];
                subElementContent = [[NSString alloc] initWithData:subElementData encoding:NSUTF8StringEncoding];
                elementModel.dataValue = subElementContent;
                
                [self saveElementData:elementModel];
            }
                break;
                
            case ElementTypeSignature:
            {
                [self saveElementDataBinary:elementModel];
            }
                break;
                
            default:
                break;
        }
    }
}

//Save element's text content to the database
- (BOOL)saveElementData:(ElementModel *)elementModel
{
    FUNCTION_START;
    
    BOOL isSaved = false;
    
    if (!_dataHandler)
    {
        _dataHandler = [DataHandler new];
    }
    
    if (elementModel.dataModel && elementModel.dataModel.dataIdApp > 0)
    {
        elementModel.dataModel.data = elementModel.dataValue;
        isSaved = [_dataHandler updateDataModel:elementModel.dataModel];
    }
    else
    {
        if (![CommonUtils isValidString:elementModel.dataValue])
        {
            return isSaved;
        }
        
        DataModel *dataModel = [DataModel new];
        dataModel.certificateIdApp = _certificate.certIdApp;
        dataModel.elementId = elementModel.elementId;
        dataModel.data = elementModel.dataValue;
        
        isSaved = [_dataHandler insertDataModel:dataModel];
    }
    
    FUNCTION_END;
    return isSaved;
}

//Save element's binary content to the database
- (BOOL)saveElementDataBinary:(ElementModel *)elementModel
{
    FUNCTION_START;
    
    BOOL isSaved = false;
    
    if (!_dataBinaryHandler)
    {
        _dataBinaryHandler = [DataBinaryHandler new];
    }
    
    if (elementModel.dataBinaryModel && elementModel.dataBinaryModel.dataBinaryIdApp > 0)
    {
        elementModel.dataBinaryModel.dataBinary = elementModel.dataBinaryValue;
        isSaved = [_dataBinaryHandler updateDataBinaryModel:elementModel.dataBinaryModel];
    }
    else
    {
        if (![CommonUtils isValidObject:elementModel.dataBinaryValue])
        {
            return isSaved;
        }
        
        DataBinaryModel *dataBinaryModel = [DataBinaryModel new];
        dataBinaryModel.certificateIdApp = _certificate.certIdApp;
        dataBinaryModel.elementId        = elementModel.elementId;
        dataBinaryModel.dataBinary       = elementModel.dataBinaryValue;
        
        isSaved = [_dataBinaryHandler insertDataBinaryModel:dataBinaryModel];
    }
    
    FUNCTION_END;
    return isSaved;
}

//Check All Elements Filled for only current Element Model
- (BOOL)hasAllElementsFilled
{
    
    return YES;
}

//Check Weather all Mandatore Elements are Totally Filled
- (BOOL)hasMandatoryElementsFilled
{
    return YES;
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
    [self saveAllElements:_currentSectionElements];
    
    if (--_currentSectionIndex < 0)
    {
        _currentSectionIndex = _formSections.count;
    }
    
    [self showElementsForSectionIndex:_currentSectionIndex];
}

- (IBAction)onClickNextToolBarButton:(id)sender
{
    [self saveAllElements:_currentSectionElements];
    
    if (++_currentSectionIndex >= _formSections.count)
    {
        _currentSectionIndex = 0;
    }
    
    [self showElementsForSectionIndex:_currentSectionIndex];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _formSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextLabelElementCell *cell = [tableView dequeueReusableCellWithIdentifier:FormSectionCellReuseIdentifier forIndexPath:indexPath];
    
    FormSectionModel *formSection = _formSections[indexPath.row];
    
    if(!cell)
    {
        cell = [TextLabelElementCell new];
    }
    
    cell.textLabel.text = formSection.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _currentSectionIndex)
    {
        [self saveAllElements:_currentSectionElements];
    }
    
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
