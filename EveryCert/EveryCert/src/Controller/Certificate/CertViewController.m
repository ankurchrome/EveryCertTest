//
//  CertificateViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 10/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CertViewController.h"
#import "UIView+Extension.h"
#import "MenuViewController.h"
#import "FormSectionTableViewCell.h"
#import "DrawingPDF.h"
#import "CertificatePreviewViewController.h"
#import "ExistingCertsListViewController.h"

#import "FormModel.h"
#import "SubElementModel.h"
#import "FormSectionHandler.h"
#import "ElementHandler.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"
#import "CertificateHandler.h"
#import "LookUpHandler.h"
#import "RecordHandler.h"

#define SECTION_LIST_SHOW_HIDE_ANIMATION_DURATION 0.3f
#define SECTION_LIST_BACKGROUND_ALPHA             0.6f

@interface CertViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIBarButtonItem  *_previewBarButton;
    
    IBOutlet UITableView      *_sectionTableView;
    IBOutlet UIView   *_sectionView;
    
    IBOutlet UIView   *_sectionFadedView;
    IBOutlet UIButton *_menuButton;
    IBOutlet UIButton *_prevSectionButton;
    IBOutlet UIButton *_nextSectionButton;
    IBOutlet UILabel  *_sectionTitleLabel;
    
    ElementModel       *_currentSearchElementModel;
    ElementModel       *_linkedSearchElementModel;
    LookUpHandler      *_lookupHandler;
    DataHandler        *_dataHandler;
    DataBinaryHandler  *_dataBinaryHandler;
    CertificateHandler *_certHandler;
    
    NSArray   *_formSections;
    NSMutableArray *_sectionImageStatusArray;
    NSInteger  _currentSectionIndex;
    NSInteger  _currentSectionRecordIdApp;
    BOOL       _isExistingCertificate;
    BOOL       _isLookupSection;
}
@end

@implementation CertViewController

NSString *const FormSectionCellReuseIdentifier = @"FormSectionCellIdentifier";
NSString *const ButtonTitlePreview = @"Preview";
NSString *const ButtonTitleFinish  = @"Finish";

enum Section_Image_Status
{
    FullyFilled = 0,
    PartiallyFilled = 1,
    Empty = 2
};

#pragma mark - Initialization Methods

// Initialize CertificateViewController by creating a new certificate of given form type
- (void)initializeWithForm:(FormModel *)formModel
{
    //Create a new certificate with selected form
    CertificateModel *newCertificate = [CertificateModel new];
    newCertificate.formId    = formModel.formId;
    newCertificate.name      = formModel.name;
    newCertificate.date      = [NSDate date];
    newCertificate.companyId = APP_DELEGATE.loggedUserCompanyId;
    
    _certHandler = _certHandler ? _certHandler : [CertificateHandler new];
    
    NSInteger certRowId = [_certHandler insertCertificate:newCertificate];
    
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
    
    APP_DELEGATE.certificateVC = self;
    
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
    _sectionImageStatusArray = [NSMutableArray new];
    
    for(FormSectionModel *formSectionModel in _formSections)
    {
        NSPredicate *elementsPredicate = [NSPredicate predicateWithFormat:@"sectionId = %ld", formSectionModel.sectionId];
        NSArray *elementArray = [_formElements filteredArrayUsingPredicate:elementsPredicate];
        
        // Take only those field having dataValue Field Non-Empty from all selected section elements
        NSString *emptyValue = @"";
        NSPredicate *nonEmptyElementsPedicate = [NSPredicate predicateWithFormat: @"(self.dataValue != %@) AND (self.dataValue != nil)", emptyValue];
        NSArray *nonEmptyElementsArray        = [elementArray filteredArrayUsingPredicate:nonEmptyElementsPedicate];
        
        // Except  Look Up and Line Module
        NSPredicate *allValidElementPredicate = [NSPredicate predicateWithFormat:@"(self.fieldType != 0) AND (self.fieldType != 9)"];
        NSArray *allValidElementsArray        = [elementArray filteredArrayUsingPredicate:allValidElementPredicate];
        
        // For all Fully Filled Elements Data in the Selected Section
        if(nonEmptyElementsArray.count == allValidElementsArray.count)
        {
            [_sectionImageStatusArray addObject:@(FullyFilled)];
        }
        else if(nonEmptyElementsArray.count > 1)
        {
            [_sectionImageStatusArray addObject:@(PartiallyFilled)];
        }
        else
        {
            [_sectionImageStatusArray addObject:@(Empty)];
        }
    }
}

#pragma mark -

//Intially required UI changes will be done here
- (void)makeUISetup
{
    self.title = _certificate.name;
    self.view.backgroundColor = APP_BG_COLOR;
    
    _elementTableView.superview.clipsToBounds = NO;
    _elementTableView.superview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _elementTableView.superview.layer.shadowOffset = CGSizeMake(0,5);
    _elementTableView.superview.layer.shadowOpacity = 0.5;
    
    _sectionTableView.backgroundColor = APP_BG_COLOR;
    _sectionTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
}

#pragma mark - Functionality Methods

//reload the section screen for the given section index
- (void)showElementsForSectionIndex:(NSInteger)sectionIndex
{
    FormSectionModel *formSection = nil;
    NSPredicate *predicate = nil;
   
    //Disable the previous section button on first section
    _prevSectionButton.enabled = !(sectionIndex == 0);
    
    //Disable the next section button and change the 'Preview' button title to 'Finish' on last section
    _nextSectionButton.enabled = !(sectionIndex == (_formSections.count-1));
    _previewBarButton.title    = _nextSectionButton.enabled ? ButtonTitlePreview : EMPTY_STRING;
    if([_previewBarButton.title isEqualToString:EMPTY_STRING]) // Do this to dont see fluctuation in chaning the PreviewButtton Tittle
    {
        _previewBarButton.title = ButtonTitleFinish;
    }
    
    //Reload element table with selected form section
    if (_formSections && sectionIndex < _formSections.count)
    {
        //get elements for given section and reload the table with the filtered elements
        formSection = [_formSections objectAtIndex:sectionIndex];
        predicate = [NSPredicate predicateWithFormat:@"sectionId = %ld", formSection.sectionId];
        _currentSectionElements = [_formElements filteredArrayUsingPredicate:predicate];
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:sectionIndex inSection:0];
        [_sectionTableView selectRowAtIndexPath:sectionIndexPath
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionNone];
        
        _sectionTitleLabel.text = formSection.title;
    }
    
    //Check that the current section is lookup section
    predicate = [NSPredicate predicateWithFormat:@"fieldType = %ld", ElementTypeSearch];
    NSArray *searchElements = [_currentSectionElements filteredArrayUsingPredicate:predicate];
    
    if (searchElements && searchElements.count > 0)
    {
        _isLookupSection = YES;
        _currentSearchElementModel = [searchElements firstObject];
        _currentSectionRecordIdApp = _currentSearchElementModel.recordIdApp;
        
        //Check that if search element is linked with other element if yes then linked element must be filled first
        if (_currentSearchElementModel.linkedElementId > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"elementId = %ld", _currentSearchElementModel.linkedElementId];
            NSArray *linkedElements = [_formElements filteredArrayUsingPredicate:predicate];
            
            if (linkedElements && linkedElements.count > 0)
            {
                _linkedSearchElementModel = [linkedElements firstObject];
                _currentSearchElementModel.linkedRecordIdApp = _linkedSearchElementModel.recordIdApp;
                
                if (_linkedSearchElementModel.recordIdApp <= 0)
                {
                    //linked element hasn't filled yet, back to previous screen
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE_WARNING message:_currentSearchElementModel.popUpMessage preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ALERT_ACTION_TITLE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                               {
                                                   [APP_DELEGATE.certificateVC backToPreviousSection];
                                               }];
                    
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            else
            {
                _linkedSearchElementModel = nil;
            }
        }
    }
    else
    {
        _isLookupSection = NO;
        _currentSectionRecordIdApp = 0;
        _currentSearchElementModel = nil;
    }
    
    [self manageCheckBoxElement];
}

// Show the section list(with animations) to pick a section randomly
- (void)showSectionView
{
    [_sectionTableView setFrameX:-_sectionTableView.frameWidth];
    _sectionView.hidden = NO;
    _sectionFadedView.alpha = 0.0;
    
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

// Show the section list(with animations)
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
    //** Change the Status ImageView according to the DataValue in it, ie. Circle with tick for fully filled Element and only circle for particlly filled
    
    // Take only those field having dataValue Field Non-Empty from all selected section elements
    NSString *emptyValue = @"";
    NSPredicate *nonEmptyElementsPedicate = [NSPredicate predicateWithFormat: @"(self.dataValue != %@) AND (self.dataValue != nil)", emptyValue];
    NSArray *nonEmptyElementsArray        = [elements filteredArrayUsingPredicate:nonEmptyElementsPedicate];
    
    // Except  Look Up and Line Module
    NSPredicate *allValidElementPredicate = [NSPredicate predicateWithFormat:@"(self.fieldType != 0) AND (self.fieldType != 9)"];
    NSArray *allValidElementsArray        = [elements filteredArrayUsingPredicate:allValidElementPredicate];
    
    
    NSIndexPath *indexPath = _sectionTableView.indexPathForSelectedRow;
    __unused NSInteger indexPathValue = indexPath.row;
    FormSectionTableViewCell *cell = (FormSectionTableViewCell*)[_sectionTableView cellForRowAtIndexPath:indexPath];
    cell.statusImageView.hidden = NO;
    
    // For all Fully Filled Elements Data in the Selected Section
    if(nonEmptyElementsArray.count == allValidElementsArray.count)
    {
        cell.statusImageView.image = [UIImage imageNamed:@"TickMarkIcon.png"];
        [_sectionImageStatusArray replaceObjectAtIndex:indexPathValue withObject:@(FullyFilled)];
        
    }
    // For Partially Filled Elements Data in the Selected Section
    else if(nonEmptyElementsArray.count > 1)
    {
        if (LOGS_ON) NSLog(@"Partially Filled");
        cell.statusImageView.image = [UIImage imageNamed:@"RadioButtonCheckedIcon.png"];
        [_sectionImageStatusArray replaceObjectAtIndex:indexPathValue withObject:@(PartiallyFilled)];
    }
    else
    {
        cell.statusImageView.hidden = YES;
        [_sectionImageStatusArray replaceObjectAtIndex:indexPathValue withObject:@(Empty)];
    }
    
    if (![self hasMandatoryElementsFilled]) return;
    
    //Create a new lookup record if not previously selected
    if (_isLookupSection && _currentSectionRecordIdApp <= 0)
    {
        [self createLookupRecord];
    }
    
    for (ElementModel *elementModel in elements)
    {
        switch (elementModel.fieldType)
        {
            case ElementTypeTextField:
            case ElementTypeTextView:
            case ElementTypePickListOption:
            case ElementTypeRadioButton:
            case ElementTypeLookup:
            case ElementTypeSearch:
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
        elementModel.recordIdApp = _currentSectionRecordIdApp;
    }
}

//Save element's text content to the database
- (BOOL)saveElementData:(ElementModel *)elementModel
{
    FUNCTION_START;
    
    BOOL isSaved = false;
    
    _dataHandler   = _dataHandler ? _dataHandler : [DataHandler new];
    _lookupHandler = _lookupHandler ? _lookupHandler : [LookUpHandler new];
    
    elementModel.dataValue = elementModel.dataValue ? elementModel.dataValue : EMPTY_STRING;
    
    if (_isLookupSection)
    {
        NSInteger lookupIdApp = [_lookupHandler getLookupIdAppOfFieldNo:elementModel.fieldNumberExisting record:_currentSectionRecordIdApp];
        
        if (lookupIdApp > 0)
        {
            //update lookup fields data with element data
            NSDictionary *columnInfo = @{
                                         LookUpDataValue: elementModel.dataValue,
                                         ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                         IsDirty: @(true)
                                         };
            
            isSaved = [_lookupHandler updateInfo:columnInfo recordIdApp:lookupIdApp];
        }
        else
        {
            if ([CommonUtils isValidString:elementModel.dataValue])
            {
                //Insert field data with newly created lookup record
                LookUpModel *lookupModel = [LookUpModel new];
                
                lookupModel.lookUpListId  = elementModel.lookUpListIdExisting;
                lookupModel.recordIdApp   = _currentSectionRecordIdApp;
                lookupModel.fieldNumber   = elementModel.fieldNumberExisting;
                lookupModel.option        = EMPTY_STRING;
                lookupModel.dataValue     = elementModel.dataValue;
                lookupModel.sequenceOrder = elementModel.sequenceOrder;
                lookupModel.companyId     = APP_DELEGATE.loggedUserCompanyId;
                
                if (_linkedSearchElementModel)
                {
                    lookupModel.linkedRecordIdApp = _linkedSearchElementModel.recordIdApp;
                }
                
                [_lookupHandler insertLookupModel:lookupModel];
            }
        }
    }
    
    if (elementModel.dataIdApp > 0)
    {
        //update existing data with modified data
        NSDictionary *columnInfo = @{
                                     DataValue: elementModel.dataValue,
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
        
        isSaved = [_dataHandler updateInfo:columnInfo recordIdApp:elementModel.dataIdApp];
    }
    else
    {
        //Allow empty data to insert for search type element only
        if (![CommonUtils isValidString:elementModel.dataValue] && elementModel.fieldType != ElementTypeSearch)
        {
            return isSaved;
        }
        
        DataModel *dataModel = [DataModel new];
        dataModel.certificateIdApp = _certificate.certIdApp;
        dataModel.elementId   = elementModel.elementId;
        dataModel.recordIdApp = _currentSectionRecordIdApp;
        dataModel.data        = elementModel.dataValue;
        dataModel.companyId   = APP_DELEGATE.loggedUserCompanyId;
        dataModel.formId      = _certificate.formId;
        
        isSaved = [_dataHandler insertDataModel:dataModel];
        
        if (isSaved)
        {
            if (LOGS_ON) NSLog(@"saved data model: %@", dataModel);
            
            elementModel.recordIdApp = _currentSectionRecordIdApp;
            elementModel.dataIdApp = dataModel.dataIdApp;
        }
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
    
    if (elementModel.dataBinaryIdApp > 0)
    {
        //update existing binary data with modified data
        NSDictionary *columnInfo = @{
                                     DataBinaryValue: elementModel.dataBinaryValue,
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
        
        isSaved = [_dataBinaryHandler updateInfo:columnInfo recordIdApp:elementModel.dataBinaryIdApp];
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

//Check Whether all Mandatory Elements are filled correctly
- (BOOL)hasMandatoryElementsFilled
{
    BOOL result = false;
    
    for (ElementModel *elementModel in _currentSectionElements)
    {
        if ([CommonUtils isValidString:elementModel.dataValue])
        {
            result = YES;
            break;
        }
    }
    
    return result;
}

// Manage Check/Uncheck CheckBox Element
- (void)manageCheckBoxElement
{
    if (_currentSectionRecordIdApp <= 0)
    {
        //When RecordId App not Exist
        [_elementTableView reloadWithElements:_currentSectionElements];
    }
    else
    {
        //When RecordidApp Exists
        
        ElementModel *elementModel = [[_currentSectionElements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.fieldType = 10"]] firstObject];
        
        if([CommonUtils isValidObject:elementModel])
        {
            elementModel.dataValue = @"NO";
        }
        
        [_elementTableView reloadWithElements:[_currentSectionElements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.fieldType != 10"]]];
    }
}

#pragma mark - LookupRecords(SearchElement) Methods

// Called when a record gets selected from lookup list and do the following steps
- (void)setupForSelectedLookupRecord:(NSInteger)recordIdApp
{
    _lookupHandler = _lookupHandler ? _lookupHandler : [LookUpHandler new];
    _dataHandler   = _dataHandler ? _dataHandler : [DataHandler new];
    
    if (_currentSectionRecordIdApp > 0)
    {
        [_dataHandler deleteLinkedDataForRecord:_currentSectionRecordIdApp
                                    certificate:_certificate.certIdApp];
    }
    
    _currentSectionRecordIdApp = recordIdApp;
    
    NSArray *lookupRecordFields = [_lookupHandler getAllFieldsOfRecord:_currentSectionRecordIdApp];
    
    for (ElementModel *elementModel in _currentSectionElements)
    {
        for (LookUpModel *lookupRecordField in lookupRecordFields)
        {
            if (elementModel.fieldNumberExisting == lookupRecordField.fieldNumber)
            {
                elementModel.dataValue = lookupRecordField.dataValue;
            }
        }
        elementModel.recordIdApp = recordIdApp;
    }
    
    [self manageCheckBoxElement];
}

// Called when New button tapped from lookup list and then following steps will be occur
- (void)setupForNewLookupRecord
{
    _dataHandler = _dataHandler ? _dataHandler : [DataHandler new];
    
    if (_currentSectionRecordIdApp > 0)
    {
        [_dataHandler deleteLinkedDataForRecord:_currentSectionRecordIdApp
                                    certificate:_certificate.certIdApp];
    }
    
    _currentSectionRecordIdApp = 0;
    
    for (ElementModel *elementModel in _currentSectionElements)
    {
        elementModel.recordIdApp = 0;
        elementModel.dataValue   = EMPTY_STRING;
    }
    
    //[_elementTableView reloadData];
    [self manageCheckBoxElement];
}

// Create a new record in 'record' table
- (BOOL)createLookupRecord
{
    RecordHandler *recordHandler = [RecordHandler new];
    
    _currentSectionRecordIdApp = [recordHandler insertRecordForCompanyId:APP_DELEGATE.loggedUserCompanyId];
    
    return _currentSectionRecordIdApp > 0 ? YES : NO;
}

// Move to previous section of form
- (void)backToPreviousSection
{
    [self showElementsForSectionIndex:--_currentSectionIndex];
}

#pragma mark - IBActions & Event Methods

// Approve the certificate and show the pdf preview of the form
- (IBAction)previewButtonTapped:(id)sender
{
    //Issued the certificate
    if (!_certificate.issuedApp)
    {
        _certHandler = _certHandler ? _certHandler : [CertificateHandler new];
        
        _certificate.issuedApp = YES;
        
        NSDictionary *columnInfo = @{
                                     CertificateIssuedApp: @(_certificate.issuedApp),
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
        
        [_certHandler updateInfo:columnInfo recordIdApp:_certificate.certIdApp];
    }
    
    //Create a certificate pdf by drawing all elements data on pdf
    DrawingPDF *drawingPdf = [DrawingPDF new];
    
    [drawingPdf drawElements:_formElements
                 onPdfLayout:_certificate.backgroundPdfPath
                      saveAs:_certificate.pdfPath];
    
    //pop to home view controller and add CertList and CertPreview view controller manually
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    for (NSInteger i = viewControllers.count; i > 0; i--)
    {
        NSInteger index = i - 1;
        
        UIViewController *vc = viewControllers[index];
        
        if (vc == APP_DELEGATE.homeVC)
        {
            break;
        }
        else
        {
            [viewControllers removeObject:vc];
        }
    }
    
    ExistingCertsListViewController *existingCertsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExistingCertsListVC"];
    
    [viewControllers addObject:existingCertsVC];
    
    CertificatePreviewViewController *certPreviewVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificatePreviewVC"];
    [certPreviewVC initializeWithCertificate:_certificate];
    
    [viewControllers addObject:certPreviewVC];
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

// Reload the previous section of current section
- (IBAction)previousSectionButtonTapped:(id)sender
{
    [self saveAllElements:_currentSectionElements];
    
    [self showElementsForSectionIndex:--_currentSectionIndex];
}

// Reload the next section of current section
- (IBAction)nextSectionButtonTapped:(id)sender
{
    [self saveAllElements:_currentSectionElements];
    
    [self showElementsForSectionIndex:++_currentSectionIndex];
}

// Show/hide the section list drawer
- (IBAction)menuButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    if(_sectionView.hidden)
    {
        [self showSectionView];
    }
    else
    {
        [self hideSectionView];
    }
}

// Move to home screen
- (IBAction)homeButtonTapped:(id)sender
{
    if (APP_DELEGATE.homeVC)
    {
        [self.navigationController popToViewController:APP_DELEGATE.homeVC animated:YES];
    }
}

// Hide the section list drawer when tapped on background
- (IBAction)sectionFadedViewTapped:(id)sender
{
    [self hideSectionView];
}

// Show the section list drawer when right swipe on table
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
    
    NSInteger imageStatus = [_sectionImageStatusArray[indexPath.row] integerValue];
    
    switch (imageStatus) {
        case FullyFilled:
        {
            cell.statusImageView.hidden = NO;
            cell.statusImageView.image = [UIImage imageNamed:@"TickMarkIcon.png"];
        }
            break;
        case PartiallyFilled:
        {
            cell.statusImageView.hidden = NO;
            cell.statusImageView.image = [UIImage imageNamed:@"RadioButtonCheckedIcon.png"];
        }
            break;
        case Empty:
        {
            cell.statusImageView.hidden = YES;
        }
            break;
    }
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
