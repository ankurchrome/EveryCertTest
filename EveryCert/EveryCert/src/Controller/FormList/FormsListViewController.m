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
    NSArray *_userFormStatus;
    NSMutableArray *_activeFormList;
    NSMutableArray *_hiddenFormList;
    CompanyUserHandler *_companyUserHandler;
    __weak IBOutlet UISearchBar *_filterCertificateSearchBar;
    
    enum FormStatusEnum
    {
        ActiveForms = 0,
        HiddenForms = 1
    };
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
    
    // contains all the From id that conatins for status 0 or 1 i.e. Hidden and show Forms
    CompanyUserModel *companyUserModel = [_companyUserHandler getCompanyUserModelForFieldName:UserFormStatusValue
                                                                                    ComapnyId:APP_DELEGATE.loggedUserCompanyId
                                                                                       UserId:APP_DELEGATE.loggedUserId];
    // Fetch Array From JSON Data of Comapny User
    NSArray *dataArrayList = [NSJSONSerialization JSONObjectWithData:[companyUserModel.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    _userFormStatus = dataArrayList;
    
    NSArray *hiddenFormsArray = [self getFromIdListFromCompanyUserJSONdata:_userFormStatus andStatus: 1]; // By Default Show forms will be shown
    
    // Remove all the FormId form _filterFormsList array that have hiden forms
    if(hiddenFormsArray.count)
    {
        // Filters all formId inside an array of Form Model from all User Form Status Array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", hiddenFormsArray];
        NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
        [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
    }
    else
    {
        [self refreshFormListWithUnwantedArrayList:nil];
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
    
    // Convert all Array String Object into NSNumber
    for(int count = 0 ; count < filteredFormIdArray.count ; count++)
    {
        [filteredFormIdArray replaceObjectAtIndex:count withObject:filteredFormIdArray[count]];
    }
    return filteredFormIdArray;
}

// Update Active / Hidden and Filtered Form List value and Reload the Table
- (void)refreshFormListWithUnwantedArrayList:(NSArray *)filteredFormModelArray
{
    [_filterFormsList removeAllObjects];                            // Clear old _filterFormsList Obejcts
    [_filterFormsList addObjectsFromArray:_allFormsList];           // Assign all objects from _allFormsList Objects
    [_filterFormsList removeObjectsInArray:filteredFormModelArray]; // Clear Selected Data
    
    [_activeFormList removeAllObjects];     // Clears all Old Object, if exist
    [_hiddenFormList removeAllObjects];     // Clears all Old Object, if exist
    
    // contains all the From id that conatins for status 0 or 1 i.e. Hidden and show Forms
    CompanyUserModel *companyUserModel = [_companyUserHandler getCompanyUserModelForFieldName:UserFormStatusValue
                                                                 ComapnyId:APP_DELEGATE.loggedUserCompanyId
                                                                    UserId:APP_DELEGATE.loggedUserId];
    // Fetch Array From JSON Data of Comapny User
    NSArray *dataArrayList = [NSJSONSerialization JSONObjectWithData:[companyUserModel.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

    _userFormStatus = dataArrayList;
    
    _hiddenFormList = [[NSMutableArray alloc]initWithArray:[self getFromIdListFromCompanyUserJSONdata:_userFormStatus andStatus:1]];
    
    // Filters all formId inside an array of Form Model from all User Form Status Array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self.formId IN %@)", _hiddenFormList];
    _activeFormList = [[NSMutableArray alloc]initWithArray:[_allFormsList filteredArrayUsingPredicate:predicate]];
    _activeFormList = [NSMutableArray arrayWithArray:[_activeFormList valueForKey:@"formId"]];
    
    [_formListTableView reloadData];
}

- (void)insertUpdateIntoCompanyUserTable
{
    NSMutableArray *userFormStatusArray = [NSMutableArray new];
    for(id formId in _hiddenFormList)
    {
        NSMutableDictionary *userFormStatusDictionary = [NSMutableDictionary new];
        [userFormStatusDictionary setObject:formId forKey:kFormId];
        [userFormStatusDictionary setObject:@1 forKey:kStatus];
        [userFormStatusArray addObject:userFormStatusDictionary];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userFormStatusArray
                                                       options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Here Update or Insert the form status value in Company user table with 1 with respect to the corresponding Form Id
    if(_userFormStatus.count > 0)
    {
        // Update Query into Company User Table
        
        CompanyUserModel *companyUser = [_companyUserHandler getCompanyUserModelForFieldName:UserFormStatusValue
                                                                                   ComapnyId:APP_DELEGATE.loggedUserCompanyId
                                                                                      UserId:APP_DELEGATE.loggedUserId];
        
        NSDictionary *dictionary = @{
                                     DataValue : jsonString,
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     IsDirty: @(true)
                                     };
      __unused BOOL checkUpdate =  [_companyUserHandler updateInfo:dictionary recordIdApp: companyUser.companyUserIdApp];
    }
    else
    {
        // InsertQuery into Company User Table
        CompanyUserModel *companyUser = [CompanyUserModel new];
        companyUser.companyId = APP_DELEGATE.loggedUserCompanyId;
        companyUser.userId    = APP_DELEGATE.loggedUserId;
        companyUser.fieldName = UserFormStatusValue;
        companyUser.data      = jsonString;
        
        [_companyUserHandler insertCompanyUser:companyUser];
    }
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
    
    //Work for move the Hidden forms in the show list
    if(_hideShowArrayList[indexPath.row] == FormStatusHide)
    {
        // Change the Title Text of Hide Show button in _hideShowArrayList
        [_hideShowArrayList replaceObjectAtIndex:indexPath.row withObject:FormStatusShow];
        
        // Here Insert or Update Form status value in the Company user Table with 1 with Respect to the corresponding Form id
        //[_hiddenFormList removeObject:formModel.formId];    //TODO: code not working , replace thisd code with the removal of that perticular object that contains this sam e formId from array
        
        [self insertUpdateIntoCompanyUserTable];
    }
    
    //Work for Push the form to the Hide List
    else if(_hideShowArrayList[indexPath.row] == FormStatusShow)
    {
        // Change the Title Text of Hide Show button in _hideShowArrayList
        [_hideShowArrayList replaceObjectAtIndex:indexPath.row withObject:FormStatusHide];
        // [_hiddenFormList addObject:@(formModel.formId).stringValue];    // Add One More formId to the list of Hidden Forms
        
        if(formModel.sequenceOrder == 0)    // If the swipe Cell is Header then Hide its sub Forms also
        {
            NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"self.categoryId == %@", formModel.categoryId];
            NSArray *headerFormsList = [_activeFormList filteredArrayUsingPredicate:predicate];   // Includes Header + its sub forms
            
            for(id formId in headerFormsList)
            {
                [_hiddenFormList addObject:formId];
            }
        }
        
        // If the swipe cell is not Header then check weather it is alone , if yes then Hide its Header also
        else
        {
            NSPredicate *predicate       = [NSPredicate predicateWithFormat:@"self.categoryId = %d", formModel.categoryId];
            NSArray *sameCategoryIdForms = [_allFormsList filteredArrayUsingPredicate:predicate];
            
            NSPredicate *checkHeaderExistPredicate = [NSPredicate predicateWithFormat:@"self.categoryId = 0"];
            NSArray *headerForm = [_allFormsList filteredArrayUsingPredicate:checkHeaderExistPredicate];
            
            if(sameCategoryIdForms.count == 2 && headerForm.count)
            {
                // As cell is the last sub Form of its Header so Hide its Header also
                for(id formId in headerForm)
                {
                    [_hiddenFormList addObject:formId];
                }
            }
            else
            {
                // Hide only the sub form
                [_hiddenFormList addObject:@(formModel.formId).stringValue];
            }
        }
        
        [self insertUpdateIntoCompanyUserTable];
    }
    
    [_filterFormsList removeObjectAtIndex:indexPath.row];
    
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
        case ActiveForms:
        {
            // Filters all formId inside an array of Form Model from all User Form Status Array
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", _hiddenFormList];
            NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
            [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
        }
            break;
            
        case HiddenForms:
        {
            // Filters all formId inside an array of Form Model from all User Form Status Array
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", _activeFormList];
            NSArray *filteredFormModelArray = [_allFormsList filteredArrayUsingPredicate:predicate];
            [self refreshFormListWithUnwantedArrayList:filteredFormModelArray];
        }
            break;
    }
}

@end