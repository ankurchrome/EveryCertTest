//
//  SignatureElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 12/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "SignatureElementCell.h"
#import "SignatureDrawingView.h"

@implementation SignatureElementCell
{    
    __weak IBOutlet UIImageView *_checkMarkImageView;
    __weak IBOutlet UIImageView *_arrowImageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet SignatureDrawingView *_signatureDrawingView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (SignatureElementCell *)initWithModel:(ElementModel *)formElement
{
     [self fillWithData:formElement.dataValue];
    _titleLabel.text = formElement.label;
    return self;
}

//Fill the element controls with the given data
- (void)fillWithData:(id)data
{
    FUNCTION_START;
    
    if (data && [data isKindOfClass:[NSData class]])
    {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image)
        {
            _checkMarkImageView.image = [UIImage imageNamed:AccessoryCheckMarkImageName];
        }
        else
        {
            _checkMarkImageView.image = nil;
        }
    }
    
    FUNCTION_END;
}

- (void)showSignatureView:(UITapGestureRecognizer *)senderTap
{
    UIImage *signImage = [UIImage imageWithData:self.elementModel.dataBinary];

    SignatureViewController *signatureVC = [[SignatureViewController alloc] initWithImage:signImage];
    
    signatureVC.delegate = self;
    signatureVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootController presentViewController:signatureVC animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyboardWillResignNotification
                                                        object:nil];
}

#pragma mark - IBActions

- (IBAction)onClickClearSignatureDrawingButton:(id)sender {
        //Reload the view
    [_signatureDrawingView clearImage];
}


#pragma mark - SignatureViewControllerDelegate Methods

- (void)imagePicked:(UIImage *)pickedImage
{
    if (pickedImage)
    {
        _checkMarkImageView.image = [UIImage imageNamed:AccessoryCheckMarkImageName];
        
    }
    else
    {
        _checkMarkImageView.image = nil;
        self.elementModel.dataValue = nil;
    }
    
    self.elementModel.dataBinary = UIImagePNGRepresentation(pickedImage);
}

@end
