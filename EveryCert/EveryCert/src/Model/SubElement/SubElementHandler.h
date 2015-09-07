//
//  SubElementHandler.h
//  EveryCert
//
//  Created by Ankur Pachauri on 27/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "BaseHandler.h"
#import "SubElementModel.h"

@interface SubElementHandler : BaseHandler


/**
 Fetch all sub elements of given element
 @param  elementIdApp App id of an element whose elements needs to get
 @return NSArray Returns a list of SubElementModel objects of given element
 */
- (NSArray *)getAllSubElementsOfElement:(NSInteger)elementIdApp;

/**
 Fetch all sub elements of given element and initialize all sub elements with given element info
 @param  elementIdApp App id of an element whose elements needs to get
 @param  elementInfoText Json format text containing info of all subelements of given element
 @return NSArray Returns a list of SubElementModel objects of given element
 */
- (NSArray *)getAllSubElementsOfElement:(NSInteger)elementIdApp withInfo:(NSString *)elementInfoText;

@end