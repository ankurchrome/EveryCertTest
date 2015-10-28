//
//  ECSyncManager.h
//  EveryCert
//
//  Created by Ankur Pachauri on 21/10/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECSyncManager : NSObject

/**
 Start syncing all the database tables with server.
 @return void
 */
- (void)startCompleteSync;

- (void)downloadForm:(NSInteger)formId;

@end
