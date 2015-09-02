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
 Returns a list of all forms with given permissions from the database
 @param  permissions A list of permissions in string separated by commas
 @return NSArray A list of all forms
 */
- (NSArray *)getAllFormsWithPermissions:(NSString *)permissions;

@end
