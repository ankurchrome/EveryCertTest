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

#define SECTION_LIST_SHOW_HIDE_ANIMATION_DURATION 0.3f
#define SECTION_LIST_BACKGROUND_ALPHA             0.6f

@interface CertificateViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIBarButtonItem  *_previewBarButton;
    IBOutlet ElementTableView *_elementTableView;
    IBOutlet UITableView      *_sectionTableView;
    IBOutlet UIView   *_sectionView;
    IBOutlet UIView   *_sectionFadedView;
    IBOutlet UIButton *_menuButton;
    IBOutlet UIButton *_prevSectionButton;
    IBOutlet UIButton *_nextSectionButton;
    IBOutlet UILabel  *_sectionTitleLabel;
    
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
NSString *const ButtonTitlePreview = @"Preview";
NSString *const ButtonTitleFinish  = @"Finish";

#pragma mark - Initialization Methods

// Initialize CertificateViewController by creating a new certificate of given form type
- (void)initializeWithForm:(FormModel *)form
{
    //Create a new certificate with selected form
    CertificateModel *newCertificate = [CertificateModel new];
    newCertificate.formId    = form.formId;
    newCertificate.name      = form.name;
    newCertificate.date      = [NSDate date];
    newCertificate.companyId = APP_DELEGATE.loggedUserCompanyId;
    
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
    self.title = _certificate.name;
    self.view.backgroundColor = APP_BG_COLOR;
    
    _sectionTableView.backgroundColor = APP_BG_COLOR;
    _sectionTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
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

    //First Section
    _prevSectionButton.enabled = !(sectionIndex == 0);
    
    //Last Section
    _nextSectionButton.enabled = !(sectionIndex == (_formSections.count-1));
    _previewBarButton.title    = _nextSectionButton.enabled ? ButtonTitlePreview : ButtonTitleFinish;
    
    if (_formSections && sectionIndex < _formSections.count)
    {
        formSection = [_formSections objectAtIndex:sectionIndex];
        
        _sectionTitleLabel.text = formSection.title;
        
        predicate = [NSPredicate predicateWithFormat:@"sectionId = %ld", formSection.sectionId];
        
        _currentSectionElements = [_formElements filteredArrayUsingPredicate:predicate];
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:sectionIndex inSection:0];
        [_sectionTableView selectRowAtIndexPath:sectionIndexPath
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionNone];
        [_elementTableView reloadWithElements:_currentSectionElements];
    }
}

- (void)showSectionView
{
    [_sectionTableView setFrameX:-_sectionTableView.frameWidth];
    _sectionView.hidden = NO;
    
    [UIView animateWithDuration:SECTION_LIST_SHOW_HIDE_ANIMATION_DURATION
                     animations:^
     {
         [_sectionTableView setFrameX:0];
         _sectionFadedView.alpha = SECTION_LIST_BACKGROUND_ALPHA;
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void)hideSectionView
{
    [UIView animateWithDuration:SECTION_LIST_SHOW_HIDE_ANIMATION_DURATION
                     animations:^
     {
         [_sectionTableView setFrameX:-_sectionTableView.frameWidth];
         _sectionFadedView.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         _sectionView.hidden = YES;
         [_sectionTableView setFrameX:0];
     }];
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
        dataModel.companyId = APP_DELEGATE.loggedUserCompanyId;
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
        dataBinaryModel.companyId        = APP_DELEGATE.loggedUserCompanyId;
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
    [self saveAllElements:_currentSectionElements];
    
//    if (--_currentSectionIndex < 0)
//    {
//        _currentSectionIndex = _formSections.count;
//    }
    
    [self showElementsForSectionIndex:--_currentSectionIndex];
}

- (IBAction)nextSectionButtonTapped:(id)sender
{
    [self saveAllElements:_currentSectionElements];
    
//    if (++_currentSectionIndex >= _formSections.count)
//    {
//        _currentSectionIndex = 0;
//    }
    
    [self showElementsForSectionIndex:++_currentSectionIndex];
}

- (IBAction)menuButtonTapped:(id)sender
{
    if(_sectionView.hidden)
    {
        [self showSectionView];
    }
    else
    {
        [self hideSectionView];
    }
}

- (IBAction)homeButtonTapped:(id)sender
{
    if (APP_DELEGATE.homeVC)
    {
        [self.navigationController popToViewController:APP_DELEGATE.homeVC animated:YES];
    }
}

- (IBAction)previewButtonTapped:(id)sender
{
    
}

- (IBAction)sectionFadedViewTapped:(id)sender
{
    [self hideSectionView];
}

- (IBAction)onSwipeElementTable:(id)sender
{
    [self showSectionView];
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
    
    _currentSectionIndex = indexPath.row;
    
    [self hideSectionView];
    [self showElementsForSectionIndex:_currentSectionIndex];
}

@end
