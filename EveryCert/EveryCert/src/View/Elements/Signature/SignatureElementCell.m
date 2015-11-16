//
//  SignatureElementCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SignatureElementCell.h"
#import "SignatureViewController.h"

@interface SignatureElementCell ()<SignatureViewControllerDelegate>

@end

@implementation SignatureElementCell
{    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIView  *_signatureView;
    IBOutlet UIImageView *_signImageView;
    IBOutlet UIButton *_signatureButton;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initializeWithElementModel:(ElementModel *)elementModel
{
    [super initializeWithElementModel:elementModel];
    
    _titleLabel.text = elementModel.label;
    
    _signatureView.layer.cornerRadius = 5;
    _signatureView.layer.borderWidth  = 1;
    _signatureView.layer.borderColor  = [[UIColor darkGrayColor] CGColor];
    
    if (elementModel.dataBinaryValue)
    {
        _signImageView.image = [UIImage imageWithData:elementModel.dataBinaryValue];
    }
}

#pragma mark - IBActions

- (IBAction)signatureViewTapped:(id)sender
{
    UIImage *signImage = [UIImage imageWithData:self.elementModel.dataBinaryValue];
    SignatureViewController *signatureVC = [[SignatureViewController alloc] initWithImage:signImage];
    signatureVC.delegate = self;
    
    UINavigationController *signatureNC = [[UINavigationController alloc] initWithRootViewController:signatureVC];
    signatureNC.modalPresentationStyle = UIModalPresentationFormSheet;
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootController presentViewController:signatureNC animated:YES completion:nil];
}

#pragma mark - SignatureViewControllerDelegate Methods

- (void)imagePicked:(UIImage *)pickedImage
{
    self.elementModel.dataBinaryValue = UIImagePNGRepresentation(pickedImage);
    _signImageView.image = pickedImage;
}

@end
