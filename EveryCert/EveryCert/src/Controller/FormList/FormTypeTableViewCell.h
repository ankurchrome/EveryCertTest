//
//  FormTypeTableViewCell.h
//  EveryCert
//
//  Created by Ankur Pachauri on 09/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormTypeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *installLabelHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewButtonlWidthConstraint;


@end
