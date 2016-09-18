//
//  Global.h
//  Shooting App
//
//  Created by Payal Patel on 03/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//


#import <sqlite3.h>


#ifndef Shooting_App_Global_h
#define Shooting_App_Global_h

#define String(s, ...) [NSString stringWithFormat:(s), ##__VA_ARGS__]
#define Err(s, ...) //NSLog(@"\nError: <%s> \t%@",__FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
#define FBOX(x) [NSNumber numberWithFloat:x]

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-,._"
#define AppName @"CarFlusher App"
#define DBFile @"shooting.sqlite"

#define AdsShow 0
//TextField maximum length
#define MAXLENGTH 20






@class DBFunctions;
@class Functions;
@class PSDatabase;
@class ViewStyle;
@class APIFunctions;

// Class Object
@class UserRegister;



#import "DBFunctions.h"
#import "Functions.h"
#import "PSDatabase.h"
#import "ViewStyle.h"
#import "APIFunctions.h"

// Class Object
#import "UserRegister.h"

#endif
