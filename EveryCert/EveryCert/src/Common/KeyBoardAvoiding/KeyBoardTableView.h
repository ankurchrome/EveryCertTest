//
//  KeyBoardScrollView.h
//  KeyBoardTesting
//
//  Created by Ashiwani on 11/24/14.
//  Copyright (c) 2014 Chromeinfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBoardTableView : UITableView <UITextFieldDelegate, UITextViewDelegate>

//used to set the content size set call in view didload only
-(void)contentSizeToFit;

// Remove the Keyboard Hide/Show Observer
- (void)removeObserver;

@end