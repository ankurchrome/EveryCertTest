//
//  FormElementModel.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementModel.h"

@implementation ElementModel

// Override init
- (id)init
{
    self = [super init];
    if(self)
    {
        self.companyUserDataValue = EMPTY_STRING;
        self.dataValue            = EMPTY_STRING;
        self.popUpMessage         = EMPTY_STRING;
        self.label                = EMPTY_STRING;
        self.fieldName            = EMPTY_STRING;
    }
    return self;
}

// Initialize object with the info stored in ResultSet
- (void)setFromResultSet: (FMResultSet *)resultSet
{
    NSString *attributes         = nil;
    NSData   *attributesData     = nil;
    NSDictionary *attributesInfo = nil;
    
    if (resultSet)
    {
        self.elementId          = [resultSet intForColumn:ElementId];
        self.sectionId          = [resultSet intForColumn:FormSectionId];
        self.formId             = [resultSet intForColumn:FormId];
        self.fieldType          = [resultSet intForColumn:ElementFieldType];
        self.fieldName          = [resultSet stringForColumn:ElementFieldName];
        self.sequenceOrder      = [resultSet intForColumn:ElementSequenceOrder];
        self.label              = [resultSet stringForColumn:ElementLabel];
        self.originX            = [resultSet intForColumn:ElementOriginX];
        self.originY            = [resultSet intForColumn:ElementOriginY];
        self.height             = [resultSet intForColumn:ElementHeight];
        self.width              = [resultSet intForColumn:ElementWidth];
        self.pageNumber         = [resultSet intForColumn:ElementPageNumber];
        self.minCharLimit       = [resultSet intForColumn:ElementMinCharLimit];
        self.maxCharLimit       = [resultSet intForColumn:ElementMaxCharLimit];
        self.linkedElementId    = [resultSet intForColumn:ElementLinkedElementId];
        self.modifiedTimestamp  = [resultSet doubleForColumn:ModifiedTimeStamp];
        self.archive            = [resultSet boolForColumn:Archive];
        self.popUpMessage       = [resultSet stringForColumn:ElementPopUpMessage];
        self.lookUpListIdNew      = [resultSet intForColumn:ElementLookUpListIdNew];
        self.fieldNumberNew       = [resultSet intForColumn:ElementFieldNumberNew];
        self.lookUpListIdExisting = [resultSet intForColumn:ElementLookUpListIdExisting];
        self.fieldNumberExisting  = [resultSet intForColumn:ElementFieldNumberExisting];
        
        attributes     = [resultSet stringForColumn:ElementPrintedTextFormat];
        attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
        
        if (attributesData)
        {
            attributesInfo = [NSJSONSerialization JSONObjectWithData:attributesData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        }

        self.printedTextFormat = attributesInfo;
    }
}

@end