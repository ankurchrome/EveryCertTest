//
//  ElementTableViewController.h
//  EveryCert
//
//  Created by Mayur Sardana on 17/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificateModel.h"
#import "FormSectionModel.h"
#import "ElementTableViewCell.h"
#import "KeyBoardTableView.h"

@interface ElementTableView : KeyBoardTableView

@property (nonatomic, strong) NSArray *elementModels;

/**
 Returns an initialized object with certificate & section info and fetch elements of specified form's section
 @param  certificate CertificateModel object containing information about the certificate
 @param  formSectionModel FormSectionModel object containing information about section of the certificate
 @return An initialized object of FormDetailsTableViewController
 */
- (id)initWithElements:(NSArray *)elementModelArray;

/**
 Reload all Elements of the Element TableView
 @param  id ID Object contains Element type with respect to an Element
 */
- (void)reloadWithElements:(NSArray *)elementModelArray;

@end
