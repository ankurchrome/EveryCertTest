//
//  RegistrationViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TextFieldElementCell.h"

@interface RegistrationViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UILabel *_termsAndServicesLabel;
    __weak IBOutlet UITableView *_signUpLabel;
    NSArray *_elementsArray;
}
@end

@implementation RegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _elementsArray = @[@"Name", @"Email Address", @"Password"];
    [_signUpLabel registerNib:[UINib nibWithNibName:@"TextFieldElementCell" bundle:nil] forCellReuseIdentifier:TextFieldReuseIdentifier];
    _signUpLabel.estimatedRowHeight = 64.0;
    _signUpLabel.rowHeight = UITableViewAutomaticDimension;
    _signUpLabel.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;          // Hide Back Button
}

#pragma mark - IBActions

- (IBAction)onClickSignInButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _elementsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldElementCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldReuseIdentifier];
    if(!cell)
    {
        cell = [TextFieldElementCell new];
    }
    [cell initWithData:_elementsArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frameHeight / _elementsArray.count;
}
@end
