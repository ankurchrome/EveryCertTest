//
//  FormElementModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementModel.h"

@implementation ElementModel

NSString *const kElementFontSize  = @"ElementFontSize";
NSString *const kElementFontColor = @"ElementFontColor";
NSString *const kElementFontName  = @"ElementFontName";
NSString *const kDefaultText      = @"DefaultText";

NSString *const kElementPickListType = @"PickListType";
NSString *const kElementRadioButtons = @"RadioButtons";
NSString *const kElementRadioButtonTitle = @"RadioButtonTitle";
NSString *const kElementRadioButtonSelectedIndex = @"RadioButtonSelectedIndex";

// This Method is used to Set all Model's Properties with the Result Set
- (void)initWithResultSet:(FMResultSet *)resultSet
{
    NSString *attributes         = nil;
    NSData   *attributesData     = nil;
    NSDictionary *attributesInfo = nil;
    
    if (resultSet)
    {
        self.elementId          = [resultSet intForColumn:ElementId];
        self.elementSectionId   = [resultSet intForColumn:ElementSectionId];
        self.elementFormId      = [resultSet intForColumn:ElementFormId];
        self.fieldType          = [resultSet intForColumn:ElementFieldType];
        self.fieldName          = [resultSet stringForColumn:ElementFieldName];
        self.sequenceOrder      = [resultSet intForColumn:ElementSequenceOrder];
        self.label              = [resultSet stringForColumn:ElementLabel];
        self.originX            = [resultSet intForColumn:ElementOriginX];
        self.originY            = [resultSet intForColumn:ElementOriginY];
        self.height             = [resultSet intForColumn:ElementHeight];
        self.width              = [resultSet intForColumn:ElementWidth];
        self.pageNumber         = [resultSet intForColumn:ElementPageNumber];
        self.minCharLimit       = [resultSet intForColumn:ElementMinChar];
        self.maxCharLimit       = [resultSet intForColumn:ElementMaxChar];
        self.linkedElementId    = [resultSet intForColumn:ElementLinkedElementId];
        self.modifiedTimestamp  = [resultSet stringForColumn:ModifiedTimeStamp];
        self.archive            = [resultSet intForColumn:Archive];
        self.popUpMessage       = [resultSet stringForColumn:ElementPopUpMessage];
        self.lookUpIdNew        = [resultSet intForColumn:ElementLookUpListIdNew];
        self.fieldNumberNew     = [resultSet intForColumn:ElementFieldNumberNew];
        self.lookUpIdExisting   = [resultSet intForColumn:ElementFieldNumberExisting];
        self.fieldNumberExisting= [resultSet intForColumn:ElementFieldNumberExisting];
        
        attributes     = [resultSet stringForColumn:ElementPrintedTextFormat];
        attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
        attributesInfo = [NSJSONSerialization JSONObjectWithData:attributesData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        self.elementPrintedTextFormat = attributesInfo;
    }
}
@end