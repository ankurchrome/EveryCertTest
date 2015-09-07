//
//  SignatureViewController.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 06/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "SignatureViewController.h"
#import "SignatureDrawingView.h"

@interface SignatureViewController ()
{
    __weak IBOutlet SignatureDrawingView *_signatureView;
    __weak IBOutlet UIView *_sigParentView;
    
    UIImage *_selectedImage;
}
@end

@implementation SignatureViewController

NSString *const SignatureViewControllerNibName = @"SignatureViewController";

// Initialize the Signature controller with the given image. User can clear it and redraw on it.
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:SignatureViewControllerNibName bundle:nil];
    
    if (self)
    {
        _selectedImage = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if (_selectedImage)
    {
        [_signatureView setImage:_selectedImage];
        [_signatureView setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBOutlet Methods

- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearButtonTapped:(id)sender
{
    [_signatureView clearImage];
}

- (IBAction)doneButtonTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(imagePicked:)])
    {
        [_delegate imagePicked:_signatureView.image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
