//
//  FormsListViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 06/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormsListViewController.h"
#import "CertificateViewController.h"
#import "FormHandler.h"
#import "FormModel.h"

@interface FormsListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tableView;
    NSArray *_allFormsList;
}
@end

@implementation FormsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FormHandler *formHandler = [FormHandler new];
    _allFormsList            = [[NSArray alloc]initWithArray:[formHandler allForms]];
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Change the color of Navigation Bar's Title Color on view Appear
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

#pragma mark -IBActions


- (IBAction)onClickHomeBarButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allFormsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [UITableViewCell new];
    }
    FormModel *formModel = _allFormsList[indexPath.row];
    cell.textLabel.text = formModel.title;
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const CertificateViewControllerIdentifier  = @"CertificateViewController";
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CertificateViewController *certificateViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:CertificateViewControllerIdentifier];
    
    FormModel *formModel             = _allFormsList[indexPath.row];
    certificateViewController.formId = formModel.formId;
    
    [self.navigationController pushViewController:certificateViewController animated:YES];
}

@end
