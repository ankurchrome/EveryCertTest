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
 Returns a list of all the sections of specified form
 @param  formIdApp A form id app being used in table 'section'
 @return NSArray A list of FormSectionModel objects
 */
- (NSArray *)getAllSectionsOfForm:(NSInteger)formIdApp;

@end
