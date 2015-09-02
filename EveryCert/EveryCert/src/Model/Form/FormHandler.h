//
//  FormHandler.h
//  MultiFormApp
//
//  Created by Ankur Pachauri on 16/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "BaseHandler.h"
#import "FormModel.h"

@interface FormHandler : BaseHandler

/**
 Fetch the form information from database for a specified form name
 @param  NSString formName
 @return FormModel A FormModel object initialized with form information
 */
- (FormModel *)formByName:(NSString *)formName;

/**
 Return a list of all forms from the database
 @return NSArray A list of all forms
 */
- (NSArray *)allForms;

@end
