//
//  LookUpHandler.h
//  EveryCert
//
//  Created by Mayur Sardana on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseHandler.h"
#import "LookUpModel.h"

@interface LookUpHandler : BaseHandler

- (NSInteger)getLookupIdAppOfFieldNo:(NSInteger)fieldNumber record:(NSInteger)recordIdApp;

// Insert a LookupModel object information into lookup table.
- (NSInteger)insertLookupModel:(LookUpModel *)lookupModel;

- (NSArray *)getAllLookupRecordsForList:(NSInteger)lookupListId linkedRecordId:(NSInteger)linkedRecordIdApp companyId:(NSInteger)companyId;

- (NSArray *)getAllFieldsOfRecord:(NSInteger)recordIdApp;

@end
