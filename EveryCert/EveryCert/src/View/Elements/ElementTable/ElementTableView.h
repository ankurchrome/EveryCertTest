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
#import "KeyBoardScrollView.h"

@interface ElementTableView : KeyBoardScrollView

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

/**
 Save data of all elements of selected section of form
 @return void
 */
- (void)saveAllElementsData;

/*!
 Check All Elements Filled for only current Element Model
 @return : BOOL A Object under which all Elements in a Table View are checked
 */
- (BOOL)hasAllElementsFilled;

/**
 Check Weather all Mandatore Elements are Totally Filled
 @return BOOL A Object under which all Mandatory Elements are checked
 */
- (BOOL)hasMandatoryElementsFilled;

@end
