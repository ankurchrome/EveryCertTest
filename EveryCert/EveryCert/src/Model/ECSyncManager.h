//
//  ECSyncManager.h
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionSync)(BOOL success, NSError *error);

@interface ECSyncManager : NSObject

/**
 Start syncing all the database tables with server.
 @return void
 */
- (void)startCompleteSyncWithCompletion:(CompletionSync)completion;

- (void)backupDataWithCompletion:(CompletionSync)completion;

- (void)downloadForm:(NSInteger)formId completion:(CompletionSync)completion;;

@end
