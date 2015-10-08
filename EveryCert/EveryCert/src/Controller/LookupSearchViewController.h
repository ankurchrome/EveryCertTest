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

- (void)initializeWithSearchElement:(ElementModel *)element;

- (void)reloadWithLookupRecords:(NSArray *)lookupRecords;

@end
