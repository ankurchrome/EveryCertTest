//
//  PhotoElementCell.m
//  EveryCert
//
//  Created by Mayur Sardana on 09/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "PhotoElementCell.h"

@implementation PhotoElementCell
{
    __weak IBOutlet UIButton *_photoAddButton;
    __weak IBOutlet UIButton *_removeButton;
    
    UIImagePickerController *_imagePickerController;
    __weak IBOutlet UIImageView *_imageView;
}

- (PhotoElementCell *)initWithModel:(ElementModel *)formElement
{
    _imagePickerController.allowsEditing = YES;
    _imagePickerController = [[UIImagePickerController alloc]init];
    if(!_imageView.image)
    {
        _imageView.image = nil;
    }
    return self;
}

#pragma mark- IBAction

//When user wish to remove the Photo
- (IBAction)onClickRemoveButton:(id)sender
{
    _imageView.image = nil;
    _removeButton.hidden   = YES;
    _photoAddButton.hidden = NO;
}

// When user wish to addPhoto by Clicking this Button
- (IBAction)onClickAddPhoto:(id)sender
{
    _imagePickerController.delegate = self;
    
    UIActionSheet *editPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera" , @"Library" , nil];
    
    [editPhotoActionSheet showInView:self];
}

#pragma mark - Private Methods

// Returns the view controller from which the view is present
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

// Open the Gallery at the Time of Editing Avatar
- (void)openGallery
{
    NSString *const GalleryUnAvailableMessage = @"No Gallery Available";
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // pick Image from Photo Library Source
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [[self viewController] presentViewController:_imagePickerController animated:YES completion:NULL];
    }
    
    // When there is no Availibility of Gallery
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:GalleryUnAvailableMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Code for Handling the AlertButton
            
        }];
        [alertController addAction:action];
    }
}

// Open Camera while Editing Avatar
- (void)openCamera
{
    NSString *const CameraUnAvailableMessage = @"No Camera Available";
    
    // Check for availibility of Camera
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        // Allocate Memory to Image Picker
        _imagePickerController = [[UIImagePickerController alloc]init];
        
        // pick Image from Camera Source
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self viewController] presentViewController:_imagePickerController animated:YES completion:NULL];
    }
    
    // When there is no Availibility of Camera
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:CameraUnAvailableMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Code for Handling the AlertButton
            
        }];
        [alertController addAction:action];
        [[self viewController] presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark- UIImagePickerControllerDelegate

// Image Picker Controller for Displaying Image on Image View
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _imageView.image = image;
    if(_imageView.image == nil)
    {
        _photoAddButton.hidden = NO;
        _removeButton.hidden = YES;
    }
    else
    {
        _photoAddButton.hidden = YES;
        _removeButton.hidden = NO;
    }
    
    // Go Back to Image View Screen
    [_imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ActionSheet's Delegate -

// Find Index Position of Action Sheet and Perform Operations
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self openCamera];
    }
    else if(buttonIndex == 1)
    {
        [self openGallery];
    }
    else
    {
        [actionSheet removeFromSuperview];
    }
}

@end
