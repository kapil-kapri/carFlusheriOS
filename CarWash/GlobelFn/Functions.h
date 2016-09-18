//
//  Functions.h
//  Shooting App
//
//  Created by Payal Patel on 03/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Functions : NSObject

#pragma mark - Obj/Dictonary
+ (NSMutableDictionary *) Object_TO_Dict:(id) myObj;
+ (id) Dict_TO_Object:(NSDictionary *) dbData withObject:(id)myObj;

+(BOOL)IsiPhoneDevice;

#pragma mark - Date
+ (NSString *)formatDate:(NSDate *)date;
+(NSDate *)convertStringToDate:(NSString *)strDate;

#pragma mark - color
+(UIColor*)colorWithHexString:(NSString*)hex;

#pragma mark - Email Validation
+ (BOOL)validateEmailWithString:(NSString*)email;

#pragma mark - About Link
+(void)openAboutLink;

#pragma mark Time Function
+(int)stringTimeComponentSeprate:(NSString *)value;
+(NSString *)integerTimeConvertString:(int)value;

#pragma mark - SHA1 Encryption
+(NSString*) sha1:(NSString*)input;

@end
