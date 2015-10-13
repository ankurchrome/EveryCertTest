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

/**
 Initialize the cell with the given record and fill UI controls from it.
 @param  lookupRecordInfo A NSDictionary object contains info about a lookup record.
 @return void
 */
- (void)initializeWithLookupRecord:(NSDictionary *)lookupRecordInfo;

extern NSString *const LookupRecordCellIdentifier;

@end
