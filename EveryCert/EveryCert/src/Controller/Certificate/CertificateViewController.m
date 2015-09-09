//
//  CertificateViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CertificateViewController.h"
#import "UIView+Extension.h"
#import "MenuViewController.h"
#import "FormSectionTableViewCell.h"
#import "ElementTableView.h"

#import "FormModel.h"
#import "SubElementModel.h"
#import "FormSectionHandler.h"
#import "ElementHandler.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"
#import "CertificateHandler.h"

@interface CertificateViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet ElementTableView *_elementTableView;
    __weak IBOutlet UITableView *_sectionTableView;
    __weak IBOutlet UIView      *_sectionView;

    IBOutlet UILabel *_sectionTitleLabel;
    
    
//    float _deviceHeight;
//    float _deviceWidth;
//    BOOL  _certificateTableViewShow;
//    
//    int  _indexPathRow;
//    BOOL _hidePannel;
    
    CertificateModel  *_certificate;
    DataHandler       *_dataHandler;
    DataBinaryHandler *_dataBinaryHandler;

    NSArray   *_formSections;
    NSArray   *_formElements;
    NSArray   *_currentSectionElements;
    NSInteger  _currentSectionIndex;
    BOOL       _isExistingCertificate;
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
    _sectionTableView.clipsToBounds = NO;
    _sectionTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _sectionTableView.layer.shadowOffset = CGSizeMake(0,5);
    _sectionTableView.layer.shadowOpacity = 0.5;
}

#pragma mark - Functionality Methods

- (void)showElementsForSectionIndex:(NSInteger)sectionIndex
{
    FormSectionModel *formSection = nil;
    NSPredicate *predicate = nil;
    
    if (_formSections && sectionIndex < _formSections.count)
    {
        formSection = [_formSections objectAtIndex:sectionIndex];
        
        _sectionTitleLabel.text = formSection.title;
        
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

- (IBAction)previousSectionButtonTapped:(id)sender
{
    
}

- (IBAction)nextSectionButtonTapped:(id)sender
{
    
}

- (IBAction)menuButtonTapped:(id)sender
{
    
}

- (IBAction)homeButtonTapped:(id)sender
{
    
}



#pragma mark -

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
    FormSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FormSectionCellReuseIdentifier forIndexPath:indexPath];
    
    FormSectionModel *formSection = _formSections[indexPath.row];
    
    cell.titleLabel.text = formSection.title;
    
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
