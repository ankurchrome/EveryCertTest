//
//  CommanUtils.h
//  EveryCert
//
//  Created by Ankur Pachauri on 03/08/15.
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

//Return dictionary object with given keys for the given dictionary
+ (NSMutableDictionary *)getInfoWithKeys:(NSArray *)keys fromDictionary:(NSDictionary *)dic;

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

/**
 Show a MBProgressHud on a view for short time of interval
 @param  text A string value to be show on hud
 @param  timeInterval Time interval for which hud will be show
 @return void
 */
+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view forTimeInterval:(NSInteger)timeInterval;

/**
 Show an alert with single button i.e "Ok".
 @param  title Title text for the alert.
 @param  msg Message text for the alert.
 @return void
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg;

@end
