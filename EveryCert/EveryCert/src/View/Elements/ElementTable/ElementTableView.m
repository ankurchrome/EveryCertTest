//
//  ElementTableViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 17/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableView.h"
#import "SubElementModel.h"
#import "DataModel.h"
#import "DataBinaryHandler.h"
#import "DataHandler.h"
#import "CertificateViewController.h"
#import "TextFieldElementCell.h"

@interface ElementTableView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_elementModels;
    NSArray *_subElementModels;
    BOOL _isRowsInserted;
}
@end

@implementation ElementTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate   = self;
    self.dataSource = self;
    
    _isRowsInserted  = NO;
    
    [self registerNib:[UINib nibWithNibName:@"TextFieldElementCell"
                                     bundle:nil] forCellReuseIdentifier:TextFieldReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"TextViewElementCell" bundle:nil] forCellReuseIdentifier:TextViewReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"TextLabelElementCell" bundle:nil] forCellReuseIdentifier:TextLabelReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"SubElementCell" bundle:nil] forCellReuseIdentifier:SubElementsReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"TickBoxElementCell" bundle:nil] forCellReuseIdentifier:TickBoxReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"RadioButtonElementCell" bundle:nil] forCellReuseIdentifier:RadioButtonsReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"SignatureElementCell" bundle:nil] forCellReuseIdentifier:SignatureViewReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:@"LookupElementCell" bundle:nil] forCellReuseIdentifier:LookUpReuseIdentifier];
    
    self.estimatedRowHeight = 64.0;
    self.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Public Methods

//Returns an initialized object with certificate & section info and fetch elements of specified form's section
- (id)initWithElements:(NSArray *)elementModelArray
{
    self = [super init];
    
    if (self)
    {
        _elementModels = elementModelArray;
    }
    
    return self;
}

//Reload all Elements of the Element TableView
- (void)reloadWithElements:(NSArray *)elementModelArray
{
    _elementModels = elementModelArray;
    
    [self reloadData];
}

////Save data of all elements of selected section of form
//- (void)saveAllElementsData
//{
//    for (ElementModel *elementModel in _elementModels)
//    {
//        switch (elementModel.fieldType)
//        {
//            case ElementTypeSubElements:
//            {
//                //Create JSON content for Sub element's content
//                NSString *subElementContent = nil;
//                NSString *subElementKey     = nil;
//                NSData   *subElementData    = nil;
//
//                NSMutableDictionary *subElementInfo = [NSMutableDictionary new];
//
//                for (SubElementModel *subElementModel in elementModel.subElements)
//                {
//                    if (subElementModel.dataValue)
//                    {
//                        subElementKey = @(subElementModel.subElementId).stringValue;
//                        [subElementInfo setObject:subElementModel.dataValue forKey:subElementKey];
//                    }
//                }
//
//                if (subElementInfo.count <= 0)
//                {
//                    continue;
//                }
//
//                subElementData = [NSJSONSerialization dataWithJSONObject:subElementInfo options:0 error:nil];
//                subElementContent = [[NSString alloc] initWithData:subElementData encoding:NSUTF8StringEncoding];
//                elementModel.dataValue = subElementContent;
//
//                [self saveElementData:elementModel];
//            }
//                break;
//
//            case ElementTypeSignature:
//            {
//                [self saveElementDataBinary:elementModel];
//            }
//                break;
//
//            case ElementTypeTextField:
//            case ElementTypeTextView:
//            case ElementTypePickListOption:
//            case ElementTypeRadioButton:
//            case ElementTypeLookup:
//            {
//                [self saveElementData:elementModel];
//            }
//                break;
//
//            default:
//                break;
//        }
//    }
//}
//
////Check All Elements Filled for only current Element Model
//- (BOOL)hasAllElementsFilled
//{
//
//    return YES;
//}
//
////Check Weather all Mandatore Elements are Totally Filled
//- (BOOL)hasMandatoryElementsFilled
//{
//    return YES;
//}

#pragma mark - Private Method

// Show sub elements on the form element screen as sub elements of the given element
- (void)showSubElementsOfElement:(SubElementModel *)element
{
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSMutableArray *newElementModels = [[NSMutableArray alloc] initWithArray:_elementModels];
    NSIndexPath *indexPath = nil;
    
    NSUInteger elementIndex = [newElementModels indexOfObject:element];
    
    if (elementIndex == NSNotFound)
    {
        return;
    }
    
    for (UIView *subElement in element.subElements)
    {
        elementIndex++;
        
        [newElementModels insertObject:subElement atIndex:elementIndex];
        indexPath = [NSIndexPath indexPathForRow:elementIndex inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    _elementModels = newElementModels;
    
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    element.isCollapsed = NO;
}

// Hide the given sub elements on the form element screen as sub elements of the given element
- (void)hideSubElementsOfElement:(SubElementModel *)element
{
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    NSMutableArray *newElementModels = [[NSMutableArray alloc] initWithArray:_elementModels];
    NSIndexPath *indexPath = nil;
    
    NSUInteger elementIndex = [newElementModels indexOfObject:element];
    
    if (elementIndex == NSNotFound)
    {
        return;
    }
    
    for (int i = 0; i < element.subElements.count; i++)
    {
        elementIndex++;
        
        [indexes addIndex:elementIndex];
        indexPath = [NSIndexPath indexPathForRow:elementIndex inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    [newElementModels removeObjectsAtIndexes:indexes];
    
    _elementModels = newElementModels;
    
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    element.isCollapsed = YES;
}

////Save element's text content to the database
//- (BOOL)saveElementData:(ElementModel *)elementModel
//{
//    FUNCTION_START;
//
//    DataModel *dataModel = nil;
//    BOOL isSaved = false;
//
//    if (!_dataHandler)
//    {
//        _dataHandler = [DataHandler new];
//    }
//
//    dataModel = [_dataHandler dataExistForCertificate:_certificateModel.certIdApp
//                                              element:elementModel.elementIdApp];
//    if (dataModel)
//    {
//        dataModel.data = elementModel.dataValue;
//        isSaved = [_dataHandler updateDataModel:dataModel];
//    }
//    else
//    {
//        if (![CommonUtils isValidString:elementModel.dataValue])
//        {
//            return isSaved;
//        }
//
//        dataModel = [DataModel new];
//
//        dataModel.certificateIdApp = _certificateModel.certIdApp;
//        dataModel.elementId = elementModel.elementId;
//        dataModel.data = elementModel.dataValue;
//
//        isSaved = [_dataHandler insertDataModel:dataModel];
//    }
//
//    FUNCTION_END;
//    return isSaved;
//}
//
////Save element's binary content to the database
//- (BOOL)saveElementDataBinary:(ElementModel *)elementModel
//{
//    FUNCTION_START;
//
//    DataBinaryModel *dataBinaryModel = nil;
//    BOOL isSaved = false;
//
//    if (!_dataBinaryHandler)
//    {
//        _dataBinaryHandler = [DataBinaryHandler new];
//    }
//
//    dataBinaryModel = [_dataBinaryHandler dataExistForCertificate:_certificateModel.certIdApp
//                                                          element:elementModel.elementIdApp];
//    if (dataBinaryModel)
//    {
//        dataBinaryModel.data = elementModel.dataBinary;
//        isSaved = [_dataBinaryHandler updateDataBinaryModel:dataBinaryModel];
//    }
//    else
//    {
//        if (![CommonUtils isValidObject:elementModel.dataBinary])
//        {
//            return isSaved;
//        }
//
//        dataBinaryModel = [DataBinaryModel new];
//
//        dataBinaryModel.certificateIdApp = _certificateModel.certIdApp;
//        dataBinaryModel.elementId = elementModel.elementId;
//        dataBinaryModel.data = elementModel.dataBinary;
//
//        isSaved = [_dataBinaryHandler insertDataBinaryModel:dataBinaryModel];
//    }
//
//    FUNCTION_END;
//    return isSaved;
//}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _elementModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [NSString new];
    
    ElementModel *elementModel = _elementModels[indexPath.row];
    
    reuseIdentifier = EMPTY_STRING;
    
    switch (elementModel.fieldType)
    {
        case ElementTypeTextField:
        {
            reuseIdentifier = TextFieldReuseIdentifier;
        }
            break;
            
        case ElementTypeTextView:
        {
            reuseIdentifier =TextViewReuseIdentifier;
        }
            break;
            
        case ElementTypeTextLabel:
        {
            reuseIdentifier = TextLabelReuseIdentifier;
        }
            break;
            
        case ElementTypeSubElements:
        {
            reuseIdentifier = SubElementsReuseIdentifier;
        }
            break;
            
        case ElementTypeTickBox:
        {
            reuseIdentifier = TickBoxReuseIdentifier;
        }
            break;
            
        case ElementTypeRadioButton:
        {
            reuseIdentifier = RadioButtonsReuseIdentifier;
        }
            break;
            
        case ElementTypeSignature:
        {
            reuseIdentifier = SignatureViewReuseIdentifier;
        }
            break;
            
        case ElementTypeLookup:
        {
            reuseIdentifier = LookUpReuseIdentifier;
        }
            break;
            
        default:
        {
            reuseIdentifier = TextLabelReuseIdentifier;
        }
            break;
    }
    
    ElementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [ElementTableViewCell new];
    }
    
    cell = [cell initWithModel:_elementModels[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElementModel *elementModel = _elementModels[indexPath.row];
    
    switch (elementModel.fieldType)
    {
        case ElementTypeSubElements:
        {
            SubElementModel *subElement = (SubElementModel *)elementModel;
            
            if (subElement.isCollapsed)
            {
                [self showSubElementsOfElement:subElement];
            }
            else
            {
                [self hideSubElementsOfElement:subElement];
            }
        }
    }
}

@end
