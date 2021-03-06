//
//  LookupRecordTableViewCell.m
//  EveryCert
//
//  Created by Ankur Pachauri on 28/09/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "LookupRecordTableViewCell.h"

@implementation LookupRecordTableViewCell

NSString *const LookupRecordCellIdentifier = @"LookupRecordCellIdentifier";

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Initialize the cell with the given record and fill UI controls from it.
- (void)initializeWithLookupRecord:(NSDictionary *)lookupRecordInfo
{
    self.lookupRecordInfo = lookupRecordInfo;
    self.titleLabel.text  = lookupRecordInfo[LookUpRecordTitleColumnAlias];
}

@end
