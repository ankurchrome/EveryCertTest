//
//  FormElementHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "SubElementModel.h"

@interface ElementHandler : BaseHandler

/**
 Fetch all elements with their stored data(if any) of given cert and its section from the 'element' and data table.
 @param certIdApp Certificate id to check for data if exist
 @param sectionIdApp Section id of certificate's form
 @returns An array of FormElementModel objects with their data(if any), which represent each UIElement of the form
 */
- (NSArray *)allElementsOfCertificate:(NSInteger)certIdApp section:(NSInteger)sectionIdApp;

/**
 This Method is used to fetch all Elements in the Element Table that is related to Section Id
 @param  NSInteger Section id of certificate's form
 @return NSArray An Array of Elements Model with respecty to an Section Id
 */
- (NSArray *)allElementsOfSectionId:(NSInteger)sectionId;

/**
 This Method is used to fetch all Elements in the Element Table that is related to Form Id
 @param  NSInteger Section id of certificate's form
 @return NSArray An Array of Elements Model with respecty to an Section Id
 */
- (NSArray *)allElementsOfFormId:(NSInteger)formId;

/**
 This Method is used to fetch all Sub Elements in the Element Table that is related to Section Id
 @param  NSInteger Section id of certificate's form
 @return NSArray An Array of Elements Model with respecty to an Section Id
 */
- (NSArray *)subElementsOfSectionId:(NSInteger)sectionId;

@end
