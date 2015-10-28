//
//  FormElementHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 02/01/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ElementHandler.h"
#import "Constant.h"
#import "DataHandler.h"
#import "DataBinaryHandler.h"
#import "CompanyUserHandler.h"
#import "SubElementHandler.h"

@implementation ElementHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = ElementTable;
        self.appIdField    = ElementId;
        self.serverIdField = ElementId;
        self.apiName       = ApiElement;
        self.tableColumns  = @[ElementId, FormSectionId, FormId, ElementFieldType, ElementFieldName, ElementSequenceOrder, ElementLabel, ElementOriginX, ElementOriginY, ElementHeight, ElementWidth, ElementPageNumber, ElementMinCharLimit, ElementMaxCharLimit, ElementPrintedTextFormat, ElementLinkedElementId, ElementPopUpMessage, ElementLookUpListIdNew, ElementFieldNumberNew, ElementLookUpListIdExisting, ElementFieldNumberExisting, ModifiedTimeStamp, Archive];
        
        self.noLocalRecord = true;
    }
    
    return self;
}

- (NSString *)getApiCallWithTimestamp:(NSTimeInterval)timestamp
{
    return [NSString stringWithFormat:@"%@/%ld",self.apiName, self.formId];
}

// Fetch all elements of given form with their stored data(if any) of given cert
- (NSArray *)getAllElementsOfForm:(NSInteger)formId withDataOfCertificate:(NSInteger)certIdApp
{
    FMDatabaseQueue *databaseQueue    = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *elementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *query = [NSString stringWithFormat:
                             @"SELECT t1.*, t2.*, t3.*\
                             FROM\
                             (SELECT * FROM %@ WHERE %@ = %ld) t1\
                             LEFT JOIN\
                             (SELECT * FROM %@ WHERE %@ = %ld) t2\
                             ON t1.%@ = t2.%@\
                             LEFT JOIN\
                             (SELECT * FROM %@ WHERE %@ = %ld) t3\
                             ON t1.%@ = t3.%@\
                             LEFT JOIN\
                             (SELECT * FROM %@) t4\
                             ON  t2.%@ = t4.%@\
                             AND t1.%@ = t4.%@\
                             AND t1.%@ = t4.%@\
                             AND t1.%@ != 1\
                             ORDER BY %@",
                           self.tableName, FormId, (long)formId, DataTable, CertificateIdApp, (long)certIdApp, ElementId, ElementId, DataBinaryTable, CertificateIdApp, (long)certIdApp, ElementId, ElementId, LookUpTable, RecordIdApp, RecordIdApp, ElementLookUpListIdExisting, LookUpListId, ElementFieldNumberExisting, LookUpFieldNumber, Archive, ElementSequenceOrder];
        
        SubElementHandler *subElementHandler = [SubElementHandler new];
        
        FMResultSet *result = [db executeQuery:query];
        
        while ([result next])
        {
            if (LOGS_ON) NSLog(@"Result Info: %@", [result resultDictionary]);
            
            ElementModel *elementModel = [[ElementModel alloc] initWithResultSet:result];
            
            //TODO: remove the unneccessary properties and change the query accordingly
            elementModel.dataIdApp = [result intForColumn:DataIdApp];
            elementModel.dataValue = [result stringForColumn:DataValue];
            elementModel.recordIdApp = [result intForColumn:RecordIdApp];
            
//            elementModel.dataModel = [[DataModel alloc] initWithResultSet:result];
            
            elementModel.dataBinaryIdApp = [result intForColumn:DataBinaryIdApp];
            elementModel.dataBinaryValue = [result dataForColumn:DataBinaryValue];
//            elementModel.dataBinaryModel = [[DataBinaryModel alloc] initWithResultSet:result];
            
            if (elementModel.fieldType == ElementTypeSubElement)
            {
                elementModel.subElements = [subElementHandler getAllSubElementsOfElement:elementModel.elementId withInfo:elementModel.dataValue];
            }
            
            [elementModelList addObject:elementModel];
        }
    }];
    
    return elementModelList;
}

// Fetch all elements of given form
- (NSArray *)getAllElementsOfForm:(NSInteger)formId
{
    FMDatabaseQueue *databaseQueue    = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *elementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@",self.tableName, FormId, (long)formId, Archive, ElementSequenceOrder];
         
         SubElementHandler *subElementHandler = [SubElementHandler new];

         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             ElementModel *elementModel = [[ElementModel alloc] initWithResultSet:result];
             
             if (elementModel.fieldType == ElementTypeSubElement)
             {
                 elementModel.subElements = [subElementHandler getAllSubElementsOfElement:elementModel.elementId];
             }
             
             [elementModelList addObject:elementModel];
         }
     }];
    
    return elementModelList;
}

// Fetch all elements for Login screen from database
- (NSArray *)getLoginElements
{
    NSArray *loginElements = [self getAllElementsOfSection:-3];
    
    return loginElements;
}

// Fetch all elements for SignUp/CreateAccount screen from database
- (NSArray *)getSignUpElements
{
    NSArray *signUpElements = [self getAllElementsOfSection:-4];
    
    return signUpElements;
}

// Fetch all elements of given section from database
- (NSArray *)getAllElementsOfSection:(NSInteger)sectionId
{
    FMDatabaseQueue *databaseQueue    = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *elementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ != 1 ORDER BY %@", self.tableName, FormSectionId, (long)sectionId, Archive, ElementSequenceOrder];
         
         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             ElementModel *elementModel = [[ElementModel alloc] initWithResultSet:result];
             
             [elementModelList addObject:elementModel];
         }
     }];
    
    return elementModelList;
}

// Fetch all elements for Setting screen with their data from company_user & data_binary table
- (NSArray *)getSettingElementsOfCompany:(NSInteger)companyId
{
    FMDatabaseQueue *databaseQueue    = [[FMDBDataSource sharedManager] databaseQueue];
    NSMutableArray  *elementModelList = [NSMutableArray new];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"\
                            SELECT t1.*, %@, %@, %@, %@\
                            FROM\
                            (SELECT * FROM %@ WHERE %@ = %ld OR %@ = %ld) t1\
                            LEFT JOIN\
                            (SELECT * FROM %@ WHERE %@ = %ld) t2\
                            ON t1.%@ = t2.%@\
                            LEFT JOIN\
                            (SELECT * FROM %@ WHERE %@ = %ld) t3\
                            ON t1.%@ = t3.%@\
                            WHERE t1.%@ != 1\
                            ORDER BY %@, %@",
                            CompanyUserIdApp, CompanyUserData, DataBinaryIdApp, DataBinaryValue, self.tableName, FormSectionId, (long)-1, FormSectionId, (long)-2, CompanyUserTable, CompanyId, (long)companyId, ElementFieldName, CompanyUserFieldName, DataBinaryTable, CompanyId, (long)companyId, ElementId, ElementId, Archive, FormSectionId, ElementSequenceOrder];
         
         if (LOGS_ON) NSLog(@"Setting elements query: %@", query);
         
         SubElementHandler *subElementHandler = [SubElementHandler new];
         
         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             if (LOGS_ON) NSLog(@"Result Info: %@", [result resultDictionary]);
             
             ElementModel *elementModel = [[ElementModel alloc] initWithResultSet:result];
             
             //TODO: remove the unneccessary properties and change the query accordingly
             elementModel.companyUserIdApp = [result intForColumn:CompanyUserIdApp];
             elementModel.dataValue        = [result stringForColumn:CompanyUserData];
             
             elementModel.dataBinaryIdApp = [result intForColumn:DataBinaryIdApp];
             elementModel.dataBinaryValue = [result dataForColumn:DataBinaryValue];
             
             if (elementModel.fieldType == ElementTypeSubElement)
             {
                 elementModel.subElements = [subElementHandler getAllSubElementsOfElement:elementModel.elementId withInfo:elementModel.dataValue];
             }
             
             [elementModelList addObject:elementModel];
         }
     }];
    
    return elementModelList;
}

@end