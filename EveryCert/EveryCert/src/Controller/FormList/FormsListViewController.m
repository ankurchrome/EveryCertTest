//
//  FormsListViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 06/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormsListViewController.h"
#import "CertViewController.h"
#import "FormTypeTableViewCell.h"
#import "FormHandler.h"
#import "UIView+Extension.h"
#import "CompanyUserHandler.h"

#define FORM_LIST_ROW_HEIGHT 44.0

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_formListTableView;
    
    NSMutableArray *_allFormsList;
    NSMutableArray *_hideShowArrayList;
    NSMutableArray *_filterFormsList;
    NSArray *_jsonData;
    NSMutableArray *_activeFormList;
    NSMutableArray *_hiddenFormList;
    CompanyUserHandler *_companyUserHandler;
    __weak IBOutlet UISearchBar *_filterCertificateSearchBar;
}
@end

@implementation FormsListViewController

static NSString *const FormsListCellIdentifier = @"FormTypeCellIdentifier";
NSString *const FormStatusTitleInstalling = @"Installing";
NSString *const FormStatusTitleInstalled = @"Installed";
NSString *const FormStatusHide = @"Hide";
NSString *const FormStatusShow = @"UnHide";
#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BG_COLOR;
    
    _formListTableView.estimatedRowHeight = FORM_LIST_ROW_HEIGHT;
    _formListTableView.rowHeight = UITableViewAutomaticDimension;
    
    FormHandler *formHandler = [FormHandler new];
    _allFormsList = [[NSMutableArray alloc]initWithArray:
                     [formHandler getAllFormsWithPermissions:APP_DELEGATE.loggedUserPermissionGroup]];
    
    _filterFormsList    = [NSMutableArray new];
    _companyUserHandler = [CompanyUserHandler new];
    
    // contains all the From id that conatins for status 1 i.e. Hide Forms
    _jsonData = [_companyUserHandler getCompanyDetailsDataArrayForUserFormStatus];
    NSArray *hiddenFormsArray = [self getFromIdListFromCompanyUserJSONdata:_jsonData andStatus: 0]; // By Default Show forms will be shown
    
    // Remove all the FormId form _filterFormsList array that have hiden forms
    if(hiddenFormsArray.count)
    {
        // Filters all formId inside an array of Form Model from all User Form Status Array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", hiddenFormsArray];
        NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
        [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
    }
    
    _hideShowArrayList = [NSMutableArray new];
    for(__unused id count in _filterFormsList)
    {
        [_hideShowArrayList addObject:FormStatusShow];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [_formListTableView reloadData];
}

#pragma mark -  Private Methods

- (NSArray *)getFromIdListFromCompanyUserJSONdata:(NSArray *)dataArrayList andStatus:(NSInteger)status
{
    NSArray *filteredRecordsArray       = [dataArrayList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(status == %d)", status]];
    NSMutableArray *filteredFormIdArray = [[NSMutableArray alloc]initWithArray:[filteredRecordsArray valueForKey:FormId]];
    NSNumberFormatter *numberFormatter  = [NSNumberFormatter new];
    
    // Convert all Array String Object into NSNumber
    for(int count = 0 ; count < filteredFormIdArray.count ; count++)
    {
        if (LOGS_ON) NSLog(@"%@", [filteredFormIdArray class]);
        [filteredFormIdArray replaceObjectAtIndex:count withObject:[numberFormatter numberFromString:filteredFormIdArray[count]]];
    }
    return filteredFormIdArray;
}

- (void)refreshFormListWithUnwantedArrayList:(NSArray *)filteredFormModelArray
{
    [_filterFormsList removeAllObjects];                            // Clear old _filterFormsList Obejcts
    [_filterFormsList addObjectsFromArray:_allFormsList];           // Assign all objects from _allFormsList Objects
    [_filterFormsList removeObjectsInArray:filteredFormModelArray]; // Clear Selected Data
    
    [_activeFormList removeAllObjects];     // Clears all Old Object, if exist
    [_hiddenFormList removeAllObjects];     // Clears all Old Object, if exist
    
    _activeFormList = [[NSMutableArray alloc]initWithArray:[self getFromIdListFromCompanyUserJSONdata:_jsonData andStatus:0]];
    _hiddenFormList = [[NSMutableArray alloc]initWithArray:[self getFromIdListFromCompanyUserJSONdata:_jsonData andStatus:1]];
    
    [_formListTableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterFormsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FormsListCellIdentifier];
    
    FormModel *formModel = _filterFormsList[indexPath.row];
    
    cell.titleLabel.text = formModel.title;
    cell.statusLabel.hidden = !formModel.status;        //hide status label if form is saved
    cell.downloadImageView.hidden = formModel.status;   //show download icon if form is not saved
    
    if (formModel.status)
    {
        cell.statusLabel.text = FormStatusTitleInstalled;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormModel *formModel = _filterFormsList[indexPath.row];
    if(_hideShowArrayList[indexPath.row] == FormStatusHide)
    {
        // Change the Title Text of Hide Show button in _hideShowArrayList
        [_hideShowArrayList replaceObjectAtIndex:indexPath.row withObject:FormStatusShow];
        
        // Here Insert or Update Form status value in the Company user Table with 1 with Respect to the corresponding Form id
        [_hiddenFormList addObject:@(formModel.formId)];
        
        NSMutableDictionary *userFormStatusDictionary = [NSMutableDictionary new];
        for(id formId in _hiddenFormList)
        {
            [userFormStatusDictionary setObject:@1 forKey:formId];
        }
        
        // [_companyUserHandler updateUserFormStatusFromJSONData:<#(NSString *)#>];
    }
    else
    {
        // Change the Title Text of Hide Show button in _hideShowArrayList
        [_hideShowArrayList replaceObjectAtIndex:indexPath.row withObject:FormStatusHide];
        
        // Here Only Update the form status value in Company user table with 0 with respect to the corresponding Form Id
       // [_companyUserHandler updateUserFormStatusFromJSONData:<#(NSString *)#>];
    }
    
    [_filterFormsList removeObjectAtIndex:indexPath.row];
    [_hideShowArrayList removeObjectAtIndex:indexPath.row];
    
    [self refreshFormListWithUnwantedArrayList:nil];
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_hideShowArrayList[indexPath.row] == FormStatusHide)
    {
        return FormStatusShow;
    }
    else
    {
        return FormStatusHide;
    }
}

#pragma mark - TableView Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCertificate"])
    {
        NSIndexPath *indexPath = [_formListTableView indexPathForSelectedRow];
        FormModel   *formModel = _filterFormsList[indexPath.row];
        CertViewController *certificateVC = [segue destinationViewController];
        [certificateVC initializeWithForm:formModel];
    }
}

#pragma mark - UISearchBar Delegate

-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecogniser

- (IBAction)singleTapOnScreen:(id)sender
{
    [_filterCertificateSearchBar resignFirstResponder];
}

#pragma mark - IBAction

- (IBAction)segmentSwitch:(UISegmentedControl *)sender
{
    NSInteger segmentNumber = sender.selectedSegmentIndex;
    switch (segmentNumber)
    {
        case 0:
        {
            // Filters all formId inside an array of Form Model from all User Form Status Array
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", _activeFormList];
            NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
            [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
        }
            break;
            
        case 1:
        {
            // Filters all formId inside an array of Form Model from all User Form Status Array
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", _hiddenFormList];
            NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
            [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
        }
            break;
    }
}


@end