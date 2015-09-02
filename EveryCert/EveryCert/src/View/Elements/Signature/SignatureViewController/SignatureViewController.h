//
//  SignatureViewController.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignatureViewControllerDelegate <NSObject>

- (void)imagePicked:(UIImage *)pickedImage;

@end

@interface SignatureViewController : UIViewController

@property (nonatomic, strong) id<SignatureViewControllerDelegate> delegate;

/**
 Initialize the Signature controller with the given image. User can clear it and redraw on it.
 @param  image Signature image object to be show
 @return void
 */
- (id)initWithImage:(UIImage *)image;

@end

extern NSString *const SignatureViewControllerNibName;
