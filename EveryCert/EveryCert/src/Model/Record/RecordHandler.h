//
//  RecordHandler.h
//  EveryCert
//
//  Created by Ankur Pachauri on 26/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseHandler.h"
#import "RecordModel.h"

@interface RecordHandler : BaseHandler

/**
 Insert a new company's record into 'record' table and returns row id for inserted row
 @param  companyId A company id for which record is being insert
 @return NSInteger return a valid row id if record saved successfully otherwise return 0
 */
- (NSInteger)insertRecordForCompanyId:(NSInteger)companyId;

@end