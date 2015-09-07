//
//  PickListViewController.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickListViewController;

@protocol PickListViewControllerDelegate <NSObject>

- (void)pickListViewController:(PickListViewController *)pickList didSelectOptions:(NSArray *)selectedOptions;

@end

@interface PickListViewController : UIViewController

@property (nonatomic, strong) id<PickListViewControllerDelegate> delegate;

/**
 Initialize an PickListViewController object with options to be selected from the given all options
 @param  selectedOptions A list of selected options to be show selected on the pick list
 @param  allOptions A list of all the options available for the pick list to be show
 @return returns an initialized PickListViewController object
 */
- (id)initWithSelectedOptions:(NSArray *)selectedOptions allOptions:(NSArray *)allOptions;

@end
