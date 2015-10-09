//
//  SearchElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 23/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SearchElementCell.h"
#import "LookupSearchViewController.h"
#import "CertViewController.h"
#import "LookUpHandler.h"
#import "ElementTableView.h"

@interface SearchElementCell ()<UISearchBarDelegate, LookupSearchViewControllerDelegate>
{
    IBOutlet UISearchBar *_searchBar;
    
    ElementTableView *_elementTableView;
    
    LookUpHandler *_lookupHandler;
}
@end

@implementation SearchElementCell

- (void)initializeWithElementModel:(ElementModel *)elementModel elementTable:(ElementTableView *)elementTableView
{
    [super initializeWithElementModel:elementModel];
    
    _elementTableView = elementTableView;
    _searchBar.placeholder = elementModel.label;
    elementModel.dataValue = EMPTY_STRING;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _lookupHandler = _lookupHandler ? _lookupHandler : [LookUpHandler new];

    if (self.elementModel.recordIdApp > 0)
    {
        UIAlertController *alertController = nil;
        UIAlertAction     *yesAction = nil;
        UIAlertAction     *noAction = nil;
        
        alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE_WARNING
                                                              message:self.elementModel.popUpMessage
                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        yesAction = [UIAlertAction actionWithTitle:ALERT_ACTION_TITLE_YES
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
        {
            [self showLookupList];
        }];
        
        noAction = [UIAlertAction actionWithTitle:ALERT_ACTION_TITLE_NO
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction *action) {
        }];

        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        [APP_DELEGATE.window.rootViewController presentViewController:alertController
                                                             animated:YES
                                                           completion:nil];
    }
    else
    {
        [self showLookupList];
    }
    
    return NO;
}

- (void)showLookupList
{
    //Get all lookup records for element's lookup list type
    NSArray *lookupRecords = [_lookupHandler getAllLookupRecordsForList:self.elementModel.lookUpListIdExisting linkedRecordId:self.elementModel.linkedRecordIdApp companyId:APP_DELEGATE.loggedUserCompanyId];
    
    UINavigationController *lookupSearchNC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LookupSearchNC"];
    lookupSearchNC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (lookupSearchNC.topViewController && [lookupSearchNC.topViewController isKindOfClass:[LookupSearchViewController class]])
    {
        LookupSearchViewController *lookupSearchVC = (LookupSearchViewController *)lookupSearchNC.topViewController;
        lookupSearchVC.delegate = self;
        [lookupSearchVC initializeWithSearchElement:self.elementModel];
        [lookupSearchVC reloadWithLookupRecords:lookupRecords];
        
        [APP_DELEGATE.window.rootViewController presentViewController:lookupSearchNC animated:YES completion:nil];
    }
}

#pragma mark - LookupSearchViewControllerDelegate Methods

- (void)lookupSearchViewController:(LookupSearchViewController *)lookupSearchViewController didSelectLookupRecord:(NSDictionary *)lookupRecordInfo
{
    if (APP_DELEGATE.certificateVC)
    {
        NSInteger recordIdApp = [lookupRecordInfo[RecordIdApp] integerValue];
        [APP_DELEGATE.certificateVC setupForSelectedLookupRecord:recordIdApp];
    }
}

- (void)didSelectNewRecord:(LookupSearchViewController *)lookupSearchViewController
{
    if (APP_DELEGATE.certificateVC)
    {
        [APP_DELEGATE.certificateVC setupForNewLookupRecord];
    }
}

- (void)didSelectCancel:(LookupSearchViewController *)lookupSearchViewController
{
    
}

@end
