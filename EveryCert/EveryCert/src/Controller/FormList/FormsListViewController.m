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
#import "ECSyncManager.h"

#define FORM_LIST_ROW_HEIGHT 20.0

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_formListTableView;
    __weak IBOutlet UISegmentedControl *_segmentControl;
    
    NSMutableArray *_allFormsModelList;
    NSArray        *_userFormStatus;
    NSMutableArray *_activeFormModelList;
    NSMutableArray *_hiddenFormModelList;
    NSMutableArray *_filteredArray;
    NSMutableArray *_copyFilteredArray;
    BOOL _checkFirstTime;
    
    CompanyUserHandler *_companyUserHandler;
    __weak IBOutlet UISearchBar *_filterCertificateSearchBar;
    
    enum FormStatusEnum
    {
        ActiveForms = 0,
        HiddenForms = 1
    };
    
    ECSyncManager *_syncManager;
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
    _checkFirstTime = YES;
    
    FormHandler *formHandler = [FormHandler new];
    _allFormsModelList = [[NSMutableArray alloc]initWithArray:
                          [formHandler getAllFormsWithPermissions:APP_DELEGATE.loggedUserPermissionGroup]];
    
    _filteredArray      = [NSMutableArray new];
    _companyUserHandler = [CompanyUserHandler new];
    _syncManager = [ECSyncManager new];
    
    [self reloadFormListTableView];
}

#pragma mark -  Private Methods

// Fetch array from the Company User Data field
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

// Reload FormList Table View
- (void)reloadFormListTableView
{
    //** Clear All Object from all the 3 Array ie. _filteredArray, _activeFormModelList, _hiddenFormModelList
    [_filteredArray removeAllObjects];
    [_activeFormModelList removeAllObjects];
    [_hiddenFormModelList removeAllObjects];
    
    // contains all the From id that conatins for status 0 or 1 i.e. Hidden and show Forms
    CompanyUserModel *companyUserModel = [_companyUserHandler getCompanyUserModelForFieldName:UserFormStatusValue
                                                                                    ComapnyId:APP_DELEGATE.loggedUserCompanyId
                                                                                       UserId:APP_DELEGATE.loggedUserId];
    // Fetch Array From JSON Data of Comapny User
    NSArray *dataArrayList = [NSJSONSerialization JSONObjectWithData:[companyUserModel.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    // Filters all Form Model from _allFormsModelList that is Hidden
    NSArray *hiddenFormIdList = [[NSMutableArray alloc]initWithArray:[self getFromIdListFromCompanyUserJSONdata:dataArrayList andStatus:1]];
    NSPredicate *hiddenFormPredicate = [NSPredicate predicateWithFormat:@"self.formId IN %@", hiddenFormIdList];
    _hiddenFormModelList = [[NSMutableArray alloc]initWithArray:[_allFormsModelList filteredArrayUsingPredicate:hiddenFormPredicate]];
    
    // Filters all Form Model from _allFormsModelList that is Active
    NSPredicate *activeFormPredicate = [NSPredicate predicateWithFormat:@"NOT (self.formId IN %@)", hiddenFormIdList];
    _activeFormModelList = [[NSMutableArray alloc]initWithArray:[_allFormsModelList filteredArrayUsingPredicate:activeFormPredicate]];
    
    NSInteger segmentNumber = _segmentControl.selectedSegmentIndex;
    switch (segmentNumber)
    {
        case ActiveForms:
        {
            _filteredArray = [NSMutableArray arrayWithArray:_activeFormModelList];
            break;
        }
        case HiddenForms:
        {
            _filteredArray = [NSMutableArray arrayWithArray:_hiddenFormModelList];
            break;
        }
    }
    
    //** copy all filterArray to the _copyFilteredArray for searching
    [_copyFilteredArray removeAllObjects];
    _copyFilteredArray  = [NSMutableArray arrayWithArray:_filteredArray];
    [_formListTableView reloadData];
}

// Insert and Update the Comapany User Table wrt. userFormStatus
- (void)insertUpdateIntoCompanyUserTable
{
    NSMutableArray *userFormStatusArray = [NSMutableArray new];
    for(FormModel *formModel in _hiddenFormModelList)
    {
        NSMutableDictionary *userFormStatusDictionary = [NSMutableDictionary new];
        [userFormStatusDictionary setObject:@(formModel.formId) forKey:kFormId];
        [userFormStatusDictionary setObject:@1 forKey:kStatus];
        [userFormStatusArray addObject:userFormStatusDictionary];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userFormStatusArray
                                                       options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Here Update or Insert the form status value in Company user table with 1 with respect to the corresponding Form Id
    if(_hiddenFormModelList.count > 0 || _activeFormModelList.count != _allFormsModelList.count)
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
        
        NSDictionary *dictionary = @{
                                     CompanyId            : @(APP_DELEGATE.loggedUserCompanyId),
                                     UserId               : @(APP_DELEGATE.loggedUserId),
                                     ModifiedTimestampApp: @([[NSDate date] timeIntervalSince1970]),
                                     CompanyUserFieldName : UserFormStatusValue,
                                     CompanyUserData      : jsonString
                                     };
        __unused BOOL checkInsert = [_companyUserHandler insertInfo: dictionary];
    }
}

- (void)downloadForm:(FormModel *)formModel
{
    //Check for internet availability for login through server
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [CommonUtils showAlertWithTitle:ALERT_TITLE_FAILED
                                message:AlertMessageConnectionNotFound];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    hud.detailsLabelText = HudTitleFormDownloading;
    
    NSString *formPdfPath = [FORMS_BACKGROUND_LAYOUT_DIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld %@.pdf", formModel.formId, formModel.name]];
    NSURL *destinationUrl = [NSURL fileURLWithPath:formPdfPath];
    
    FormHandler *formHandler = [FormHandler new];
    
    [formHandler downloadFileWithUrl:formModel.backgroundLayout
                      destinationUrl:destinationUrl
                          retryCount:REQUEST_RETRY_COUNT
                          completion:^(NSError *error)
     {
         if (error)
         {
             [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
             
             [CommonUtils showAlertWithTitle:ALERT_TITLE_ERROR message:error.localizedDescription];
         }
         else
         {
             [_syncManager downloadForm:formModel.formId completion:^(BOOL success, NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                  {
                     [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
                     
                     if (success)
                     {
                         formModel.status = true;
                         
                         //Update form status to true in data as installed form
                         FormHandler *formHandler = [FormHandler new];
                         NSDictionary *info = @{ FormStatus : @(true) };
                         [formHandler updateInfo:info recordIdApp:formModel.formId];
                         
                         [_formListTableView reloadData];
                         
                         CertViewController *certificateVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificateVC"];
                         
                         [certificateVC initializeWithForm:formModel];
                         
                         [self.navigationController pushViewController:certificateVC animated:YES];
                     }
                     else
                     {
                         [CommonUtils showAlertWithTitle:ALERT_TITLE_ERROR message:error.localizedDescription];
                     }
                  });
              }];
         }
     }];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FormsListCellIdentifier];
    
    FormModel *formModel = _filteredArray[indexPath.row];
    
    cell.titleLabel.text = formModel.title;
    cell.statusLabel.hidden = !formModel.status; //hide status label if form is saved
    
    if (formModel.status)
    {
        cell.statusLabel.text = FormStatusTitleInstalled;
        cell.installLabelHeightContraint.constant = 23.0;
    }
    else
    {
        cell.installLabelHeightContraint.constant = 0.0;
    }
    
    // when cell is Header then change its title color and background color
    if(formModel.sequenceOrder == 0)
    {
        cell.backgroundColor = APP_BLUE_COLOR;
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.installLabelHeightContraint.constant   = 0.0;
        cell.previewButtonlWidthConstraint.constant = 0.0;
        
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        cell.titleLabel.font = font;
    }
    else
    {
        cell.backgroundColor      = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor darkGrayColor];
        cell.previewButtonlWidthConstraint.constant = 65;
        UIFont *font = [UIFont systemFontOfSize:15];
        cell.titleLabel.font = font;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    [self tableViewWillFinishLoading:tableView];
    return nil;
}

// This methosd is just for updating Self Sizing Properly between cell
//TODO: Remove It http://www.appcoda.com/self-sizing-cells/ for know about the Bug
- (void)tableViewWillFinishLoading:(UITableView *)tableView
{
    if(_checkFirstTime)
    {
        [tableView reloadData];
        _checkFirstTime = NO;
    }
}

// Work when button clcik after cell is swiped
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormModel *formModel    = _filteredArray[indexPath.row];
    NSInteger segmentNumber = _segmentControl.selectedSegmentIndex;
    
    // If the swipe Cell is Header then Hide its sub Forms also
    if(formModel.sequenceOrder == 0)
    {
        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"self.categoryId = %d", formModel.categoryId];
        
        // Includes Header + its sub forms
        NSArray *headerFormsList = [_filteredArray filteredArrayUsingPredicate:predicate];
        
        for(FormModel *formModel in headerFormsList)
        {
            if(segmentNumber == HiddenForms)
            {
                [_hiddenFormModelList removeObject:formModel];
            }
            
            else if(segmentNumber == ActiveForms)
            {
                [_hiddenFormModelList addObject:formModel];
            }
        }
    }
    
    // If the swipe cell is not Header then check weather it is alone , if yes then Hide/Show its Header also
    else
    {
        NSPredicate *predicate       = [NSPredicate predicateWithFormat:@"self.categoryId = %d", formModel.categoryId];
        NSArray *sameCategoryIdForms = [_filteredArray filteredArrayUsingPredicate:predicate];
        
        NSPredicate *checkHeaderExistPredicate = [NSPredicate predicateWithFormat:@"self.sequenceOrder = 0"];
        NSArray *headerForm = [sameCategoryIdForms filteredArrayUsingPredicate:checkHeaderExistPredicate];
        
        if(sameCategoryIdForms.count == 2 && headerForm.count)
        {
            // As cell is the last sub Form of its Header so Hide/Show its Header also
            for(FormModel *formModel in sameCategoryIdForms)
            {
                if(segmentNumber == HiddenForms)
                {
                    [_hiddenFormModelList removeObject:formModel];
                }
                
                else if(segmentNumber == ActiveForms)
                {
                    [_hiddenFormModelList addObject:formModel];
                }
            }
        }
        else
        {
            // Hide/Show only the sub form
            if(segmentNumber == HiddenForms)
            {
                [_hiddenFormModelList removeObject:formModel];
            }
            
            else if(segmentNumber == ActiveForms)
            {
                [_hiddenFormModelList addObject: formModel];
            }
        }
    }
    
    [self insertUpdateIntoCompanyUserTable];
    [self reloadFormListTableView];
    [tableView reloadData];
}

// Change title for Every Active and Hidden Forms
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger segmentNumber = _segmentControl.selectedSegmentIndex;
    switch (segmentNumber)
    {
        case ActiveForms:
        {
            return FormStatusHide;
            break;
        }
        case HiddenForms:
        {
            return FormStatusShow;
            break;
        }
    }
    return FormStatusShow;
}

#pragma mark - TableView Delegate

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowCertificate"])
    {
        NSIndexPath *indexPath = [_formListTableView indexPathForSelectedRow];
        FormModel *formModel = _filteredArray[indexPath.row];
        
        //Download the form from server if it is not already installed in the app
        if (!formModel.status)
        {
            [self downloadForm:formModel];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCertificate"])
    {
        NSIndexPath *indexPath = [_formListTableView indexPathForSelectedRow];
        FormModel   *formModel = _filteredArray[indexPath.row];
        
        CertViewController *certificateVC = [segue destinationViewController];
        [certificateVC initializeWithForm:formModel];
    }
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (!searchText || [searchText isEqualToString:EMPTY_STRING])
    {
        _filteredArray = _copyFilteredArray;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title contains[cd] %@", searchText];
        
        _filteredArray = [NSMutableArray arrayWithArray:[_copyFilteredArray filteredArrayUsingPredicate:predicate]];
    }
    
    [_formListTableView reloadData];
}

#pragma mark - IBAction

// When Segment Control is Switched From Active to InActive Forms or Vice Versa
- (IBAction)segmentSwitch:(UISegmentedControl *)sender
{
    NSInteger segmentNumber = sender.selectedSegmentIndex;
    switch (segmentNumber)
    {
        case ActiveForms:
        {
            [self reloadFormListTableView];
        }
            break;
            
        case HiddenForms:
        {
            [self reloadFormListTableView];
        }
            break;
    }
}

@end