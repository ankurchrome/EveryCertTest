//
//  ElementTableViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 17/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "ElementTableView.h"
#import "SubElementModel.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"

@interface ElementTableView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_elementModels;
}
@end

@implementation ElementTableView

NSString *const ElementCellNibName         = @"ElementCellNibName";
NSString *const ElementCellReuseIdentifier = @"ElementCellReuseIdentifier";

#pragma mark - Initialization Methods

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate   = self;
    self.dataSource = self;
    
    NSArray *elementCellInfoList = nil;
    
    elementCellInfoList = @[
                            @{
                                ElementCellNibName: ElementCellNibNameSearch,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierSearch
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameTextField,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierTextField
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameTextView,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierTextView
                                },
                            @{
                                ElementCellNibName: ElementCellNibNamePicker,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierPicker
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameLookUp,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierLookUp
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameSignature,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierSignature
                                },
                            @{
                                ElementCellNibName: ElementCellNibNamePickList,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierPickList
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameSubElement,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierSubElement
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameRadioButton,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierRadioButton
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameLine,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierLine
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameTickBox,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierTickBox
                                },
                            @{
                                ElementCellNibName: ElementCellNibNameTextLabel,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierTextLabel
                                },
                            @{
                                ElementCellNibName: ElementCellNibNamePhoto,
                                ElementCellReuseIdentifier: ElementCellReuseIdentifierPhoto
                                },
                            ];
    
    for (NSDictionary *elementCellInfo in elementCellInfoList)
    {
        UINib *cellNib = [UINib nibWithNibName:elementCellInfo[ElementCellNibName] bundle:nil];
        
        [self registerNib:cellNib forCellReuseIdentifier:elementCellInfo[ElementCellReuseIdentifier]];
    }
    
    self.estimatedRowHeight = 64.0;
    self.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark -

//Reload all Elements of the Element TableView
- (void)reloadWithElements:(NSArray *)elementModelArray
{
    _elementModels = elementModelArray;
    
    [self reloadData];
}

#pragma mark - UITableViewDatasource

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
        case ElementTypeSearch:
        {
            reuseIdentifier = ElementCellReuseIdentifierSearch;
        }
            break;

        case ElementTypeTextField:
        {
            reuseIdentifier = ElementCellReuseIdentifierTextField;
        }
            break;
            
        case ElementTypeTextView:
        {
            reuseIdentifier =ElementCellReuseIdentifierTextView;
        }
            break;
            
        case ElementTypePicker:
        {
            reuseIdentifier =ElementCellReuseIdentifierPicker;
        }
            break;
            
        case ElementTypeLookup:
        {
            reuseIdentifier = ElementCellReuseIdentifierLookUp;
        }
            break;

        case ElementTypeSignature:
        {
            reuseIdentifier = ElementCellReuseIdentifierSignature;
        }
            break;

        case ElementTypePickListOption:
        {
            reuseIdentifier = ElementCellReuseIdentifierPickList;
        }
            break;

        case ElementTypeSubElement:
        {
            reuseIdentifier = ElementCellReuseIdentifierSubElement;
        }
            break;

        case ElementTypeRadioButton:
        {
            reuseIdentifier = ElementCellReuseIdentifierRadioButton;
        }
            break;
            
        case ElementTypeLine:
        {
            reuseIdentifier = ElementCellReuseIdentifierLine;
        }
            break;
 
        case ElementTypeTickBox:
        {
            reuseIdentifier = ElementCellReuseIdentifierTickBox;
        }
            break;

        case ElementTypeTextLabel:
        {
            reuseIdentifier = ElementCellReuseIdentifierTextLabel;
        }
            break;
            
        case ElementTypePhoto:
        {
            reuseIdentifier = ElementCellReuseIdentifierPhoto;
        }
            break;
            
        default:
        {
            reuseIdentifier = ElementCellReuseIdentifierTextLabel;
        }
            break;
    }
    
    ElementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [ElementTableViewCell new];
    }
    
    [cell initializeWithElementModel:elementModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElementModel *elementModel = _elementModels[indexPath.row];
    
    switch (elementModel.fieldType)
    {
        case ElementTypeSubElement:
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

@end
