//
//  FormElementHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementHandler.h"
#import "ElementModel.h"
#import "SubElementModel.h"
#import "DataBinaryHandler.h"
#import "Constant.h"

@implementation ElementHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName  = ElementTable;
        self.appIdField = ElementId;
        self.fieldList  = [[NSArray alloc] initWithObjects:ElementId, ElementSectionId, ElementFormId, ElementFieldType, ElementFieldName, ElementSequenceOrder, ElementLabel, ElementOriginX, ElementOriginY, ElementHeight, ElementWidth, ElementPageNumber, ElementMinChar, ElementMaxChar, ElementPrintedTextFormat, ElementLinkedElementId, ModifiedTimeStamp, Archive, ElementPopUpMessage, ElementLookUpListIdNew, ElementFieldNumberNew, ElementLookUpListIdExisting, ElementFieldNumberExisting, nil];
    }
    
    return self;
}

// Fetch all elements with their stored data(if any) of given cert and its section from the 'element' and data table.
- (NSArray *)allElementsOfCertificate:(NSInteger)certIdApp section:(NSInteger)sectionIdApp
{
    ElementModel *formElementModel = nil;
    NSMutableArray *formElementModelList = [NSMutableArray new];
    
    NSString *columnString = [NSString stringWithFormat:@"t1.%@ as %@, t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@ t1.%@ as %@, t1.%@ as %@, t1.%@ as %@, t1.%@ as %@, t1.%@ as %@, t1.%@ as %@, t2.%@ as %@",  ElementId, ElementId, ElementSectionId, ElementSectionId, ElementFormId, ElementFormId, ElementFieldType, ElementFieldType, ElementFieldName, ElementFieldName, ElementSequenceOrder, ElementSequenceOrder, ElementLabel, ElementLabel, ElementOriginX, ElementOriginX, ElementOriginY, ElementOriginY, ElementHeight, ElementHeight, ElementWidth, ElementWidth, ElementPageNumber, ElementPageNumber, ElementMinChar, ElementMinChar, ElementMaxChar, ElementMaxChar, ElementPrintedTextFormat, ElementPrintedTextFormat, ElementLinkedElementId, ElementLinkedElementId, ModifiedTimeStamp, ModifiedTimeStamp, Archive, Archive, ElementPopUpMessage, ElementPopUpMessage, ElementLookUpListIdNew, ElementLookUpListIdNew, ElementFieldNumberNew, ElementFieldNumberNew, ElementLookUpListIdExisting, ElementLookUpListIdExisting, ElementFieldNumberExisting, ElementFieldNumberExisting, DataValue, DataValue];
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@\
                       FROM\
                       (SELECT * FROM %@ WHERE %@ = %ld) t1\
                       LEFT JOIN\
                       (SELECT * FROM %@ WHERE %@ = %ld) t2\
                       ON t1.%@ = t2.%@\
                       ORDER BY t1.%@", columnString, self.tableName, FormSectionId, (long)sectionIdApp, DataTable, CertificateIdApp, (long)certIdApp, ElementId, ElementId, ElementSequenceOrder];
    [_database open];
    
    DataBinaryHandler *dataBinaryHandler = [DataBinaryHandler new];
    DataBinaryModel *dataBinaryModel = nil;
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formElementModel = [ElementModel new];
        [formElementModel initWithResultSet:result];
        formElementModel.dataValue = [result stringForColumn:DataValue];
        
        if (formElementModel.fieldType == ElementTypeSignature)
        {
            dataBinaryModel = [dataBinaryHandler dataExistForCertificate:certIdApp
                                                                 element:formElementModel.elementId];
            formElementModel.dataBinary = dataBinaryModel.data;
        }
        
        if (formElementModel.fieldType == ElementTypeSubElements)
        {
            formElementModel.subElements = [self allSubElementsOfElement:formElementModel.elementId];
        }
        
        [formElementModelList addObject:formElementModel];
        
    }
    
    [_database close];
    
    return formElementModelList;
}

// Fetch all sub elements of given element
- (NSArray *)allSubElementsOfElement:(NSInteger)elementIdApp
{
    SubElementModel *subElementModel = nil;
    NSMutableArray  *subElementModelList = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld ORDER BY %@", SubElementTable, ElementId, (long)elementIdApp, ElementSequenceOrder];
    
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        subElementModel = [self formSubElementModelFromResultSet:result];
        
        [subElementModelList addObject:subElementModel];
    }
    
    return subElementModelList;
}

// Create SubElementModel object and initialized it with specified resultset
- (SubElementModel *)formSubElementModelFromResultSet:(FMResultSet *)resultSet
{
    SubElementModel *formSubElementModel = [SubElementModel new];
    
    NSString *attributes         = nil;
    NSData   *attributesData     = nil;
    NSDictionary *attributesInfo = nil;
    
    if (resultSet)
    {
        formSubElementModel.subElementId       = [resultSet intForColumn:SubElementId];
        formSubElementModel.elementId          = [resultSet intForColumn:ElementId];
        formSubElementModel.fieldType          = [resultSet intForColumn:ElementFieldType];
        formSubElementModel.fieldName          = [resultSet stringForColumn:ElementFieldName];
        formSubElementModel.sequenceOrder      = [resultSet intForColumn:ElementSequenceOrder];
        formSubElementModel.label              = [resultSet stringForColumn:ElementLabel];
        formSubElementModel.originX            = [resultSet intForColumn:ElementOriginX];
        formSubElementModel.originY            = [resultSet intForColumn:ElementOriginY];
        formSubElementModel.height             = [resultSet intForColumn:ElementHeight];
        formSubElementModel.width              = [resultSet intForColumn:ElementWidth];
        formSubElementModel.pageNumber         = [resultSet intForColumn:ElementPageNumber];
        formSubElementModel.minCharLimit       = [resultSet intForColumn:ElementMinChar];
        formSubElementModel.maxCharLimit       = [resultSet intForColumn:ElementMaxChar];
        formSubElementModel.linkedElementId    = [resultSet intForColumn:ElementLinkedElementId];
        formSubElementModel.modifiedTimestamp  = [resultSet stringForColumn:ModifiedTimeStamp];
        formSubElementModel.archive            = [resultSet intForColumn:Archive];
        formSubElementModel.popUpMessage       = [resultSet stringForColumn:ElementPopUpMessage];
        formSubElementModel.lookUpIdNew        = [resultSet intForColumn:ElementLookUpListIdNew];
        formSubElementModel.fieldNumberNew     = [resultSet intForColumn:ElementFieldNumberNew];
        formSubElementModel.lookUpIdExisting   = [resultSet intForColumn:ElementFieldNumberExisting];
        formSubElementModel.fieldNumberExisting= [resultSet intForColumn:ElementFieldNumberExisting];
        
        
        attributes     = [resultSet stringForColumn:ElementPrintedTextFormat];
        attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
        attributesInfo = [NSJSONSerialization JSONObjectWithData:attributesData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        formSubElementModel.printedTextFormat = attributesInfo;
    }
    
    return formSubElementModel;
}

//This Method is used to fetch all Elements in the Element Table that is related to Section Id
- (NSArray *)allElementsOfSectionId:(NSInteger)sectionId
{
    ElementModel *formElementModel = nil;
    NSMutableArray  *formElementModelList = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"Select * from %@ where %@ = %ld", ElementTable, ElementSectionId, (long)sectionId];
    
    [_database open];
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formElementModel = [ElementModel new];
        [formElementModel initWithResultSet:result];
        formElementModel.dataValue = [result stringForColumn:DataValue];
        
        if (formElementModel.fieldType == ElementTypeSubElements)
        {
            formElementModel.subElements = [self allSubElementsOfElement:formElementModel.elementId];
        }
        
        if (LOGS_ON) NSLog(@"%@",formElementModel.fieldName);
        [formElementModelList addObject:formElementModel];
    }
    [_database close];
    
    if (LOGS_ON) NSLog(@"%@", formElementModelList);
    return formElementModelList;
}

//This Method is used to fetch all Elements in the Element Table that is related to Form Id
- (NSArray *)allElementsOfFormId:(NSInteger)formId
{
    ElementModel *formElementModel = nil;
    NSMutableArray  *formElementModelList = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"Select * from %@ where %@ = %ld", ElementTable, ElementFormId, (long)formId];
    
    [_database open];
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formElementModel = [ElementModel new];
        [formElementModel initWithResultSet:result];
        formElementModel.dataValue = [result stringForColumn:DataValue];
        
        if (formElementModel.fieldType == ElementTypeSubElements)
        {
            formElementModel.subElements = [self allSubElementsOfElement:formElementModel.elementId];
        }
        
        if (LOGS_ON) NSLog(@"%@",formElementModel.fieldName);
        [formElementModelList addObject:formElementModel];
    }
    [_database close];
    
    if (LOGS_ON) NSLog(@"%@", formElementModelList);
    return formElementModelList;
}

//This Method is used to fetch all Sub Elements in the Element Table that is related to Section Id
- (NSArray *)subElementsOfSectionId:(NSInteger)sectionId
{
    ElementModel *formElementModel = nil;
    NSMutableArray  *formElementModelList = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"Select * from %@ where %@ = %ld AND %@ = 1", ElementTable, ElementSectionId, (long)sectionId, ElementFieldType];
    [_database open];
    FMResultSet *result = [_database executeQuery:query];
    
    while ([result next])
    {
        formElementModel = [ElementModel new];
        [formElementModel initWithResultSet:result];
        formElementModel.dataValue = [result stringForColumn:DataValue];
        
        if (formElementModel.fieldType == ElementTypeSubElements)
        {
            formElementModel.subElements = [self allSubElementsOfElement:formElementModel.elementId];
        }
        
        if (LOGS_ON) NSLog(@"%@",formElementModel.fieldName);
        [formElementModelList addObject:formElementModel];
    }
    [_database close];
    
    if (LOGS_ON) NSLog(@"%@", formElementModelList);
    return formElementModelList;
}

@end
