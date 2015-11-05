//
//  FormPreviewViewController.m
//  EveryCert
//
//  Created by Mayur Sardana on 28/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormPreviewViewController.h"

@interface FormPreviewViewController ()

@end

@implementation FormPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;  // Change Status Bar color
}

#pragma mark- IBActions

// When user click on Back Button then change it s Root View Controller
- (IBAction)onClickBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
