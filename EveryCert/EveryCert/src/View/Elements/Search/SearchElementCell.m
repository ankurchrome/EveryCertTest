//
//  SearchElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 23/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SearchElementCell.h"
#import "LookupSearchViewController.h"

@interface SearchElementCell ()<UISearchBarDelegate>
{
    IBOutlet UISearchBar *_searchBar;
}
@end

@implementation SearchElementCell

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _searchBar.placeholder = elementModel.label;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UINavigationController *lookupSearchNC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LookupSearchNC"];
    lookupSearchNC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [APP_DELEGATE.window.rootViewController presentViewController:lookupSearchNC animated:YES completion:nil];

    return NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (LOGS_ON) NSLog(@"Search text: %@", searchText);
}

@end
