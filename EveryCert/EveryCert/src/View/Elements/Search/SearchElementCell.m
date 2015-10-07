//
//  SearchElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 23/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SearchElementCell.h"
#import "LookupSearchViewController.h"
#import "CertificateViewController.h"
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
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _lookupHandler = _lookupHandler ? _lookupHandler : [LookUpHandler new];
    
    if (self.elementModel.recordIdApp > 0)
    {
        UIAlertController *alertController = nil;
        UIAlertAction     *yesAction = nil;
        
        alertController = [UIAlertController alertControllerWithTitle:self.elementModel.popUpMessage
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
        {
            
        }];
        
        [alertController addAction:yesAction];
        [APP_DELEGATE.window.rootViewController presentViewController:alertController animated:YES completion:nil];

        return NO;
    }
    
    //Get all lookup records for element's lookup list type
    NSArray *lookupRecords = [_lookupHandler getAllLookupRecordsForList:self.elementModel.lookUpListIdExisting linkedRecordId:self.elementModel.linkedElementId companyId:APP_DELEGATE.loggedUserCompanyId];
    
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
    
    return NO;
}

#pragma mark - LookupSearchViewControllerDelegate Methods

- (void)lookupSearchViewController:(LookupSearchViewController *)lookupSearchViewController didSelectLookupRecord:(NSDictionary *)lookupRecordInfo
{
    if (APP_DELEGATE.certificateVC)
    {
        [APP_DELEGATE.certificateVC fillSelectedLookupRecord:lookupRecordInfo];
    }
}

@end
