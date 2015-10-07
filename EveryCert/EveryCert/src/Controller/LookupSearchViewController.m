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

@interface LookupSearchViewController ()
{
    IBOutlet UIBarButtonItem *_cancelBarButton;
    IBOutlet UIBarButtonItem *_newBarButton;
    IBOutlet UISearchBar     *_searchBar;
    IBOutlet UITableView     *_lookupTableView;
    
    ElementModel *_elementModel;
    NSArray *_lookupRecords;
}
@end

@implementation LookupSearchViewController

NSString *const LookupSearchTitle = @"Select a record";

- (void)initializeWithSearchElement:(ElementModel *)element
{
    _elementModel = element;
    
    [self setupWithElement];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupWithElement
{
    _searchBar.placeholder = _elementModel.label;
    self.title = LookupSearchTitle;
}

- (void)reloadWithLookupRecords:(NSArray *)lookupRecords
{
    _lookupRecords = lookupRecords;
    
    if (_lookupTableView)
    {
        [_lookupTableView reloadData];
    }
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)newButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lookupRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lookupRecordInfo = nil;
    
    LookupRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LookupRecordCellIdentifier forIndexPath:indexPath];
    
    if (_lookupRecords &&  indexPath.row < _lookupRecords.count)
    {
        lookupRecordInfo = _lookupRecords[indexPath.row];
        
        [cell initializeWithLookupRecord:lookupRecordInfo];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookupRecordTableViewCell *cell = (LookupRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.lookupRecordInfo && _delegate && [_delegate respondsToSelector:@selector(lookupSearchViewController:didSelectLookupRecord:)])
    {
        [_delegate lookupSearchViewController:self didSelectLookupRecord:cell.lookupRecordInfo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
