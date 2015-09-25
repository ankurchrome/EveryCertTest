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
    IBOutlet UIBarButtonItem *_cancelBarButtonItem;
    IBOutlet UIBarButtonItem *_doneBarButtonItem;
    
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

    self.title = @"Signature";
    self.view.backgroundColor = APP_BG_COLOR;
    self.navigationItem.leftBarButtonItem  = _cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = _doneBarButtonItem;
    self.navigationController.navigationBar.barTintColor = APP_BLUE_COLOR;
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle     = UIBarStyleBlack;
    
    _signatureView.superview.layer.cornerRadius = 5;
    _signatureView.superview.layer.borderWidth  = 1;
    _signatureView.superview.layer.borderColor  = [[UIColor darkGrayColor] CGColor];

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

- (IBAction)cancelButtonTapped:(id)sender
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
