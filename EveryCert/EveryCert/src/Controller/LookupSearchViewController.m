//
//  LookupSearchViewController.m
//  EveryCert
//
//  Created by Ankur Pachauri on 28/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookupSearchViewController.h"
#import "LookupRecordTableViewCell.h"

@interface LookupSearchViewController ()
{
    IBOutlet UIBarButtonItem *_cancelBarButton;
    IBOutlet UIBarButtonItem *_newBarButton;
    IBOutlet UISearchBar     *_searchBar;
    IBOutlet UITableView     *_lookupTableView;
    
    NSArray *_lookupRecords;
}
@end

@implementation LookupSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Customer List";
    self.view.backgroundColor = APP_BG_COLOR;
    self.navigationItem.leftBarButtonItem  = _cancelBarButton;
    self.navigationItem.rightBarButtonItem = _newBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    LookupRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LookupRecordCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
