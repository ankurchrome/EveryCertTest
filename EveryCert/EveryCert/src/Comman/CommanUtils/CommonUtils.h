//
//  CommanUtils.h
//  EveryCert
//
//  Created by Mayur Sardana on 03/08/15.
//  Copyright (c) 2015 ChromeInfo Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject

//Return true if given object is valid object otherwise false
+ (BOOL)isValidObject:(id)object;

//Return true if given string is valid string otherwise false
+ (BOOL)isValidString:(NSString *)string;

//return true if text is valid with given REGEX otherwise false.
+ (BOOL)validation:(NSString *)text regularExpression:(NSString *)regex;

//Save File in document dir with given path using contents file data.
+ (BOOL)saveFile:(NSData *)fileData path:(NSString *)filePath;

//Remove File from with given path using file name.
+ (BOOL)removeFile:(NSString *)fileName path:(NSString *)filePath;

//return the Path of document dir of current app.
+ (NSString *)getDocumentDirPath;

//To get all subviews of given view which are of defined classtype
+ (NSArray *)allSubviewsOfView:(UIView *)view kindOf:(Class)classType;

//Return dictionary object with given keys for the given dictionary
+ (NSDictionary *)dictionaryWithKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic;

//Convert a hex string into the RGB colors then use them to make UIColor object.
+ (UIColor *)colorWithHexString:(NSString *)hexString;

//Convert a UIColor object into the RGB colors then use them to make hex string.
+ (NSString *)hexStringFromColor:(UIColor *)color;

/**
 Copy the DataBase from Bundle to Document Dir.
 @return return true if DB copied otherwise false.
 */
+ (BOOL)copyApplicationDatabaseIfRequired;

/**
 Remove the DataBase file from Document Dir.
 @return return true if DB copied otherwise false.
 */
+ (BOOL)removeDatabaseFromApplication;

+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view forTimeInterval:(NSInteger)timeInterval;

@end
