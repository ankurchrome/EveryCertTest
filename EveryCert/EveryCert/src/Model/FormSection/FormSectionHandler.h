//
//  FormSectionHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 03/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "FormSectionModel.h"

@interface FormSectionHandler : BaseHandler

/**
 Return a list of all the sections of specified form
 @param  formIdApp A form id app being used in table 'section'
 @return NSArray A list of FormSectionModel objects
 */
- (NSArray *)allSectionsOfForm:(NSInteger)formIdApp;

/**
 This method is used to return all Section of the Model
 @return NSArray Returns all section Model
 */
- (NSArray *)getAllSectionModel;

@end
