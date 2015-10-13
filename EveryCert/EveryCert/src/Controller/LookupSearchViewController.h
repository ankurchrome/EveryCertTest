//
//  LookupSearchViewController.h
//  EveryCert
//
//  Created by Ankur Pachauri on 28/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ElementModel, LookupSearchViewController;

@protocol LookupSearchViewControllerDelegate <NSObject>

- (void)lookupSearchViewController:(LookupSearchViewController *)lookupSearchViewController didSelectLookupRecord:(NSDictionary *)lookupRecordInfo;

- (void)didSelectNewRecord:(LookupSearchViewController *)lookupSearchViewController;

- (void)didSelectCancel:(LookupSearchViewController *)lookupSearchViewController;

@end

@interface LookupSearchViewController : UIViewController

@property (nonatomic, strong) id<LookupSearchViewControllerDelegate> delegate;

/**
 Initialize the LookupSearchViewController object with the given element to show the lookup records list of its type
 @param  element ElementModel object to show the records list of its type and setup UI accordingly
 @return void
 */
- (void)initializeWithSearchElement:(ElementModel *)element;

/**
 Reload the lookup records table with given records
 @param  lookupRecords A list of lookup records
 @return void
 */
- (void)reloadWithLookupRecords:(NSArray *)lookupRecords;

@end
