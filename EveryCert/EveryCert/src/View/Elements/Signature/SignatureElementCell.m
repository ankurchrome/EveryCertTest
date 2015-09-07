//
//  SignatureElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SignatureElementCell.h"
#import "SignatureDrawingView.h"
#import "SignatureViewController.h"

@interface SignatureElementCell ()<SignatureViewControllerDelegate>

@end

@implementation SignatureElementCell
{    
    __weak IBOutlet UIImageView *_checkMarkImageView;
    __weak IBOutlet UIImageView *_arrowImageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet SignatureDrawingView *_signatureDrawingView;
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
}

#pragma mark - IBActions

- (IBAction)onClickClearSignatureDrawingButton:(id)sender {
    //Reload the view
    [_signatureDrawingView clearImage];
}

#pragma mark -

- (void)showSignatureView:(UITapGestureRecognizer *)senderTap
{
    UIImage *signImage = [UIImage imageWithData:self.elementModel.dataBinaryValue];

    SignatureViewController *signatureVC = [[SignatureViewController alloc] initWithImage:signImage];
    
    signatureVC.delegate = self;
    signatureVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootController presentViewController:signatureVC animated:YES completion:nil];
}

#pragma mark - SignatureViewControllerDelegate Methods

- (void)imagePicked:(UIImage *)pickedImage
{
    self.elementModel.dataBinaryValue = UIImagePNGRepresentation(pickedImage);
}

@end
