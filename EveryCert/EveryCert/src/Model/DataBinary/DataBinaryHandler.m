//
//  DataBinaryHandler.m
//  MultiFormApp
//
//  Created by Ankur Pachauri on 09/07/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DataBinaryHandler.h"
#import "CertificateHandler.h"
#import "RecordHandler.h"

@implementation DataBinaryHandler

//Returns an object initialized with table related info like table name, id field, columns etc.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tableName     = DataBinaryTable;
        self.appIdField    = DataBinaryIdApp;
        self.serverIdField = DataBinaryId;
        self.apiName       = ApiDataBinary;
        self.tableColumns  = @[DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataBinaryFileName];
    }
    
    return self;
}

// Insert a DataBinaryModel object information into data_binary table.
- (BOOL)insertDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    __block BOOL success = false;
    
    dataBinaryModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataBinaryModel.isDirty = true;
    dataBinaryModel.uuid = [[NSUUID new] UUIDString];

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?,?,?,?,?,?)", self.tableName, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataBinaryFileName];
         
         success = [db executeUpdate:query, @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, @(dataBinaryModel.modifiedTimestampApp).stringValue, @(dataBinaryModel.modifiedTimestamp).stringValue, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId), dataBinaryModel.fileName];
     }];
    
    return success;
}

// Check for binary data into 'data_binary' table for an element of a certificate.
- (DataBinaryModel *)dataExistForCertificate:(NSInteger)certIdApp element:(NSInteger)elementIdApp
{
    FUNCTION_START;
    
    __block DataBinaryModel *dataBinaryModel = nil;
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %ld AND %@ = %ld", self.tableName, CertificateIdApp, (long)certIdApp, ElementId, (long)elementIdApp];
         
         FMResultSet *result = [db executeQuery:query];
         
         if ([result next])
         {
             dataBinaryModel = [[DataBinaryModel alloc] initWithResultSet:result];
         }
     }];
    
    return dataBinaryModel;
}

- (NSArray *)allDataBinaryInfoToBeDownload
{
    __block NSMutableArray *dataBinaryInfoList = [NSMutableArray new];
    
    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '' AND length(%@) > 0", self.tableName, DataBinaryValue, DataBinaryFileName];
         
         FMResultSet *result = [db executeQuery:query];
         
         while ([result next])
         {
             [dataBinaryInfoList addObject:[result resultDictionary]];
         }
     }];
    
    return dataBinaryInfoList;
}

// Update a DataBinaryModel object information into data_binary table.
- (BOOL)updateDataBinaryModel:(DataBinaryModel *)dataBinaryModel
{
    __block BOOL success = false;
    
    dataBinaryModel.modifiedTimestampApp = [[NSDate date] timeIntervalSince1970];
    dataBinaryModel.isDirty = true;

    FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ? ", self.tableName, DataBinaryIdApp, DataBinaryId, CertificateIdApp, ElementId, DataBinaryValue, ModifiedTimestampApp, ModifiedTimeStamp, Archive, Uuid, IsDirty, CompanyId, DataBinaryIdApp];
         
         success = [db executeUpdate:query, @(dataBinaryModel.dataBinaryIdApp), @(dataBinaryModel.dataBinaryId), @(dataBinaryModel.certificateIdApp), @(dataBinaryModel.elementId), dataBinaryModel.dataBinary, dataBinaryModel.modifiedTimestampApp, dataBinaryModel.modifiedTimestamp, @(dataBinaryModel.archive), dataBinaryModel.uuid, @(dataBinaryModel.isDirty), @(dataBinaryModel.companyId), @(dataBinaryModel.dataBinaryId)];
     }];
    
    return success;
}

#pragma mark - ServerSync Methods

- (NSMutableDictionary *)populateInfoForNewRecord:(NSDictionary *)info db:(FMDatabase *)db
{
    NSMutableDictionary *newRecordInfo = [CommonUtils getInfoWithKeys:self.tableColumns fromDictionary:info];
    
    //Save cert id app
    CertificateHandler *certificateHandler = [CertificateHandler new];
    NSInteger certId = [info[CertificateId] integerValue];
    NSInteger certIdApp = certId > 0 ? [certificateHandler getAppId:certId db:db] : 0;
    
    if (certIdApp <= 0)
    {
        if (LOGS_ON) NSLog(@"Certificate not found: %ld", (long)certId); return nil;
    }
    
    [newRecordInfo setObject:@(certIdApp).stringValue forKey:CertificateIdApp];
    
    // Initialise modified timestamp app with modified timestamp server for new records
    if ([info valueForKey:ModifiedTimeStampServer])
    {
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimeStamp];
        [newRecordInfo setObject:[info valueForKey:ModifiedTimeStampServer] forKey:ModifiedTimestampApp];
    }
    
    [newRecordInfo setObject:EMPTY_STRING forKey:DataBinaryValue];
    
    return newRecordInfo;
}

- (void)downloadAllDataBinary
{
    NSArray *dataBinaryInfoList = [self allDataBinaryInfoToBeDownload];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.maxConcurrentOperationCount = 10;
    
    for (NSDictionary *dataBinaryInfo in dataBinaryInfoList)
    {
        NSURL *binaryUrl = [[NSURL alloc] initWithString:dataBinaryInfo[DataBinaryFileName]];
        NSURLRequest *binaryUrlRequest = [[NSURLRequest alloc] initWithURL:binaryUrl];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:binaryUrlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [requestOperation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (LOGS_ON) NSLog(@"Data binary id: %@ Image: %@", dataBinaryInfo[DataBinaryIdApp], responseObject);
             
             FMDatabaseQueue *databaseQueue = [[FMDBDataSource sharedManager] databaseQueue];
             
             [databaseQueue inDatabase:^(FMDatabase *db)
             {
                 NSInteger recordIdApp = [dataBinaryInfo[DataBinaryIdApp] integerValue];
                 
                 if (responseObject && [responseObject isKindOfClass:[UIImage class]])
                 {
                     NSData *imageData = UIImagePNGRepresentation(responseObject);
                     
                     NSDictionary *info = @{ DataBinaryValue: imageData };
                     
                     [self updateInfo:info recordIdApp:recordIdApp db:db];
                 }
             }];
         }
                                                failure:
         ^(AFHTTPRequestOperation *operation, NSError *error)
         {
         }];
        
        [operationQueue addOperation:requestOperation];
    }
}

@end
