//
//  LookupRecordTableViewCell.h
//  EveryCert
//
//  Created by Ankur Pachauri on 28/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookupRecordTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *lookupRecordInfo;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)initializeWithLookupRecord:(NSDictionary *)lookupRecordInfo;

extern NSString *const LookupRecordCellIdentifier;

@end
