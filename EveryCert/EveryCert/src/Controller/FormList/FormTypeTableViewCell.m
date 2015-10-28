//
//  FormTypeTableViewCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 09/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "FormTypeTableViewCell.h"

@implementation FormTypeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - IBOutlet

// When user click on Preview Button to previe it Form
- (IBAction)onClickPreviewButton:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *formPreviewNC = [storyBoard instantiateViewControllerWithIdentifier:@"FormPreviewNC"];
    formPreviewNC.modalPresentationStyle = UIModalPresentationFormSheet;
    [APP_DELEGATE.window.rootViewController presentViewController:formPreviewNC animated:YES completion:nil];
}

@end
