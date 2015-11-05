//
//  LookUpHandler.h
//  EveryCert
//
//  Created by Ankur Pachauri on 14/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseHandler.h"
#import "LookUpModel.h"

@interface LookUpHandler : BaseHandler

/**
 Get the app id of given field of lookup record
 @param  fieldNumber This will be used to identify a field of lookup record
 @param  recordIdApp This will be used to identify a lookup record like Customer, Address, Appliance etc.
 @return NSInteger return app id of given field of lookup record if found otherwise return 0.
 */
- (NSInteger)getLookupIdAppOfFieldNo:(NSInteger)fieldNumber record:(NSInteger)recordIdApp;

/**
 Insert a LookupModel object information into lookup table.
 @param  lookupModel A model object of Lookup type
 @return NSInteger return app id of lookup record field if inserted successfully otherwise 0.
 */
- (NSInteger)insertLookupModel:(LookUpModel *)lookupModel;

/**
 Fetch all the lookup records of given type(Customer, Job addresses, appliances etc.) which are linked to given record if any.
 @param  lookupListId It will be used to identify the type of list like Customer, Job addresses, appliances etc.
 @param  linkedRecordIdApp It will be used to find the linked record of it
 @param  companyId It will be used to find the records of the given company
 @return NSArray A list of lookup records linked to a record if any
 */
- (NSArray *)getAllLookupRecordsForList:(NSInteger)lookupListId linkedRecordId:(NSInteger)linkedRecordIdApp companyId:(NSInteger)companyId;

/**
 Fetch all the fields of a given record
 @param  recordIdApp This will be used to identify a lookup record like Customer, Address, Appliance etc.
 @return NSArray return a list of LookupModel object and each object will represent a field no of given lookup record
 */
- (NSArray *)getAllFieldsOfRecord:(NSInteger)recordIdApp;

@end
