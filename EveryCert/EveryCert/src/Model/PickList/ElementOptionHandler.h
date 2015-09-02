//
//  ElementOptionHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "ElementOptionModel.h"

@interface ElementOptionHandler : BaseHandler

/**
 Fetch all options for given type of pick list.
 @param pickListType An integer value that specified a particular pick list.
 @returns An array of all the options of specified pick list.
 */
- (NSArray *)allOptionsOfPickListType:(NSInteger)pickListType;

/**
 This Method is used to get All Type of Burners
 @return NSArray returns all list of Burner Type
 */
- (NSArray *)getAllBurnerType;

@end