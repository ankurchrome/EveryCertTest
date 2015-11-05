//
//  LookupSearchViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 28/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookupSearchViewController.h"
#import "LookupRecordTableViewCell.h"
#import "ElementModel.h"

#define LOOKUP_RECORD_ROW_HEIGHT 44.0

@interface LookupSearchViewController ()<UISearchBarDelegate>
{
    IBOutlet UIBarButtonItem *_cancelBarButton;
    IBOutlet UIBarButtonItem *_newBarButton;
    IBOutlet UISearchBar     *_searchBar;
    IBOutlet UITableView     *_lookupTableView;
    __weak IBOutlet UIView   *_emptyRecordBackgroundView;
    
    ElementModel *_elementModel;
    NSArray *_lookupRecords;
    NSArray *_tableRecords;
}
@end

@implementation LookupSearchViewController

NSString *const LookupSearchTitle = @"Select a record";

#pragma mark - Initialization Methods

// Initialize the LookupSearchViewController object with the given element to show the lookup records list of its type
- (void)initializeWithSearchElement:(ElementModel *)element
{
    _elementModel = element;
    
    [self setupWithElement];
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BG_COLOR;
    self.navigationItem.leftBarButtonItem  = _cancelBarButton;
    self.navigationItem.rightBarButtonItem = _newBarButton;
    
    _lookupTableView.estimatedRowHeight = LOOKUP_RECORD_ROW_HEIGHT;
    _lookupTableView.rowHeight = UITableViewAutomaticDimension;
    
    if (_elementModel)
    {
        [self setupWithElement];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_lookupTableView reloadData];
}

#pragma mark - Functionality Methods

- (void)setupWithElement
{
    _searchBar.placeholder = _elementModel.label;
    self.title = LookupSearchTitle;
}

// Reload the lookup records table with given records
- (void)reloadWithLookupRecords:(NSArray *)lookupRecords
{
    _tableRecords  = lookupRecords;
    _lookupRecords = lookupRecords;
    
    if (_lookupTableView)
    {
        [_lookupTableView reloadData];
    }
}

#pragma mark - IBActions

// Cancel the lookup controller
- (IBAction)cancelButtonTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCancel:)])
    {
        [_delegate didSelectCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Notify the delegate object for new record
- (IBAction)newButtonTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectNewRecord:)])
    {
        [_delegate didSelectNewRecord:self];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (!searchText || [searchText isEqualToString:EMPTY_STRING])
    {
        _tableRecords = _lookupRecords;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"record_title contains[cd] %@", searchText];
        
        _tableRecords = [_lookupRecords filteredArrayUsingPredicate:predicate];
    }
    
    [_lookupTableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRows = _tableRecords ? _tableRecords.count : 0;
    
    if(noOfRows <= 0)
    {
        _emptyRecordBackgroundView.hidden = NO;
    }
    else
    {
        _emptyRecordBackgroundView.hidden = YES;
    }
    
    return noOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lookupRecordInfo = nil;
    
    LookupRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LookupRecordCellIdentifier forIndexPath:indexPath];
    
    if (_tableRecords &&  indexPath.row < _tableRecords.count)
    {
        lookupRecordInfo = _tableRecords[indexPath.row];
        
        [cell initializeWithLookupRecord:lookupRecordInfo];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookupRecordTableViewCell *cell = (LookupRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // Notify the delegate object for selected record
    if (cell.lookupRecordInfo && _delegate && [_delegate respondsToSelector:@selector(lookupSearchViewController:didSelectLookupRecord:)])
    {
        [_delegate lookupSearchViewController:self didSelectLookupRecord:cell.lookupRecordInfo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
