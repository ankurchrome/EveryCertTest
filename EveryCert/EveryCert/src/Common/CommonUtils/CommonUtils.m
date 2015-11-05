//
//  CommanUtils.m
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

//Return true if given object is valid object otherwise false
+ (BOOL)isValidObject:(id)object
{
    FUNCTION_START;
    
    BOOL isValid = false;
    
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        isValid = false;
    }
    else
    {
        isValid = true;
    }
    
    FUNCTION_END;
    return isValid;
}

//Return true if given string is valid string otherwise false
+ (BOOL)isValidString:(NSString *)string
{
    FUNCTION_START;
    
    BOOL isValid = false;
    
    if (!string || [string isKindOfClass:[NSNull class]] || [string isEqualToString:EMPTY_STRING])
    {
        isValid = false;
    }
    else
    {
        isValid = true;
    }
    
    FUNCTION_END;
    return isValid;
}

// Show an alert with single button i.e "OK".
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg
{
    FUNCTION_START;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:msg
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    [alert show];
    
    FUNCTION_END;
}

//Return dictionary object with given keys for the given dictionary
+ (NSMutableDictionary *)getInfoWithKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic
{
    FUNCTION_START;
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    
    for (NSString *key in keys)
    {
        id value = [dic valueForKey:key];
        
        if (!value)
            continue;
        
        [info setObject:value forKey:key];
    }
    
    FUNCTION_END;
    return info;
}

//return true if text is valid with given REGEX otherwise false.
+ (BOOL)validation:(NSString *)text regularExpression:(NSString *)regex
{
    FUNCTION_START;
    
    if (![CommonUtils isValidString:text]) return NO;
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [namePredicate evaluateWithObject:text];
}

//Return dictionary object with given keys for the given dictionary
+ (NSDictionary *)dictionaryWithKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic
{
    FUNCTION_START;
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    
    for (NSString *key in keys)
    {
        id value = [dic valueForKey:key];
        
        if (!value)
            continue;
        
        [info setObject:value forKey:key];
    }
    
    FUNCTION_END;
    return info;
}

//Save File in document dir with given path using contents file data.
+ (BOOL)saveFile:(NSData *)fileData path:(NSString *)filePath
{
    FUNCTION_START;
    
    BOOL isSave = false;
    
    NSFileManager *fileManager = nil;
    NSString *docDirPath = nil;
    NSArray  *dirPaths   = nil;
    
    if (!fileData || !filePath || [filePath isEqualToString:EMPTY_STRING])
        return isSave;
    
    fileManager = [NSFileManager defaultManager];
    dirPaths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                      NSUserDomainMask, YES);
    docDirPath  = [[dirPaths objectAtIndex:0] stringByAppendingString:filePath];
    
    isSave = [fileData writeToFile:filePath atomically:YES];
    
    FUNCTION_END;
    return isSave;
}

//Remove File from with given path using file name.
+ (BOOL)removeFile:(NSString *)fileName path:(NSString *)filePath
{
    FUNCTION_START;
    
    BOOL isRemove = false;
    
    NSFileManager *fileManager = nil;
    
    if (!fileName || [fileName isEqualToString:EMPTY_STRING] ||
        !filePath || [filePath isEqualToString:EMPTY_STRING])
        return isRemove;
    
    fileManager = [NSFileManager defaultManager];
    
    isRemove = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", filePath, fileName]
                                       error:nil];
    FUNCTION_END;
    return isRemove;
}

//return the Path of document dir of current app.
+ (NSString *)getDocumentDirPath
{
    FUNCTION_START;
    NSString *docDirPath = nil;
    NSArray  *dirPaths   = nil;
    
    dirPaths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                      NSUserDomainMask, YES);
    docDirPath  = [dirPaths objectAtIndex:0];
    
    return docDirPath;
    FUNCTION_END;
}

/**
 * @desc   : To get all subviews of given view which are of defined classtype
 * @param  : parent view as UIView & classType as Class
 * @return : NSArray of all subviews
 */
+ (NSArray *)allSubviewsOfView:(UIView *)view kindOf:(Class)classType
{
    FUNCTION_START;
    NSMutableArray *subviewArray = nil;
    subviewArray = [NSMutableArray new];
    
    for(id subView in [view subviews])
    {
        if([subView isKindOfClass:classType])
            [subviewArray addObject:subView];
        
        // if it has subviews, loop through those, too
        if([subView respondsToSelector:@selector(subviews)])
            [subviewArray addObjectsFromArray:[self allSubviewsOfView:subView kindOf:classType]];
    }
    
    return subviewArray;
    FUNCTION_END;
}

/**
 Convert a hex string into the RGB colors then use them to make UIColor object.
 @param  NSString A color hex string.
 @return UIColor A color object.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    FUNCTION_START;
    
    //TODO: Explain the code or remove the constants
    unsigned int hex;
    
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    
    int red = (hex >> 16) & 0xFF;
    int green = (hex >> 8) & 0xFF;
    int blue = (hex) & 0xFF;
    
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:1.0f];
    
    FUNCTION_END;
}

/**
 Convert a UIColor object into the RGB colors then use them to make hex string.
 @param  UIColor A color object.
 @return NSString A color hex string.
 */
+ (NSString *)hexStringFromColor:(UIColor *)color
{
    FUNCTION_START;
    
    //TODO: Explain the code or remove the constants
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(red * 255),
            lroundf(green * 255),
            lroundf(blue * 255)];
    
    FUNCTION_END;
}

// Copy the DataBase from Bundle to Document Dir.
+ (BOOL)copyApplicationDatabaseIfRequired
{
    FUNCTION_START;
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *docDirPath   = [CommonUtils getDocumentDirPath];
    NSString *dbFilePath   = [docDirPath stringByAppendingPathComponent:DATABASE_NAME];
    NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"NewEverycertDB"
                                                             ofType:@"sqlite"];
    BOOL databaseCopied = false;
    NSError *error = nil;
    
    if ( [fileManager fileExistsAtPath:dbFilePath] == YES)
    {
        if ( LOGS_ON )   NSLog(@"DataBase File Already Exist");
        return databaseCopied;
    }
    
    if ( [fileManager fileExistsAtPath:dbBundlePath] == NO)
    {
        if ( LOGS_ON )   NSLog(@"DataBase File not found in Bundle");
        return databaseCopied;
    }
    
    databaseCopied = [fileManager copyItemAtPath:dbBundlePath toPath:dbFilePath error:&error];
    
    if (error)
        if (LOGS_ON) NSLog(@"Database not copied \n Reason : %@ ", error.description);
    
    if (databaseCopied)
        if (LOGS_ON) NSLog(@"Database copied");

    if (LOGS_ON) NSLog(@"Database path: %@", dbFilePath);
    
    FUNCTION_END;
    return databaseCopied;
}

// Remove the DataBase file from Document Dir.
+ (BOOL)removeDatabaseFromApplication
{
    FUNCTION_START;
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *docDirPath = [CommonUtils getDocumentDirPath];
    NSString *dbFilePath = [docDirPath stringByAppendingPathComponent:DATABASE_NAME];
    
    BOOL databaseRemoved = false;
    
    if ( [fileManager fileExistsAtPath:dbFilePath] == NO)
    {
        if (LOGS_ON) NSLog(@"DataBase File not found in Document Dir");
    }
    
    NSError *error = nil;
    databaseRemoved = [fileManager removeItemAtPath:dbFilePath error:&error];
    
    if (error)
        if (LOGS_ON) NSLog(@"Database not removed \n Reason : %@ ", error.description);
    
    if (databaseRemoved)
        if (LOGS_ON) NSLog(@"Database has removed");
    
    FUNCTION_END;
    return databaseRemoved;
}

// Show a MBProgressHud on a view for short time of interval
+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view forTimeInterval:(NSInteger)timeInterval
{
    FUNCTION_START;
    
    MBProgressHUD *progressHud = [MBProgressHUD new];
    progressHud.mode = MBProgressHUDModeText;
    progressHud.animationType = MBProgressHUDAnimationZoomOut;
    progressHud.labelText = text;
    progressHud.removeFromSuperViewOnHide = YES;
    progressHud.minSize = CGSizeMake(120, 60);
    [view addSubview:progressHud];
    [progressHud show:YES];
    [progressHud hide:YES afterDelay:timeInterval];
    
    FUNCTION_END;
}

@end
