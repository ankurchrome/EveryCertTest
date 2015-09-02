//
//  SettingViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SettingViewController.h"
#import "ElementTableView.h"
#import "ElementHandler.h"

@interface SettingViewController ()
{
    IBOutlet ElementTableView *_settingElementTableView;

    NSArray *_settingElements;
}
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO: Get company id from logged user
    ElementHandler *elementHandler = [ElementHandler new];
    [elementHandler.database open];
    _settingElements = [elementHandler getSettingElementsOfCompany:14];
    [elementHandler.database close];
    
    [_settingElementTableView reloadWithElements:_settingElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)onClickHomeBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end