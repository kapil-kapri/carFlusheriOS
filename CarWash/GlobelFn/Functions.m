//
//  Functions.m
//  Shooting App
//
//  Created by Payal Patel on 03/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import "Functions.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Functions


//static inline double radians (double degrees) {return degrees * M_PI/180;}
#pragma mark +
#pragma mark User Defined Functions ... Start ...


+ (NSMutableDictionary *) Object_TO_Dict:(id) myObj{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([myObj class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            id obj = [myObj valueForKey:propertyName] ;
            if (obj) {
                [dict setObject:obj forKey:propertyName];
            }
            obj = nil;
            
            //NSLog(@"\n%@",propertyName);
            
        }
    }
    
    free(properties);
    return dict;
}

+ (id) Dict_TO_Object:(NSDictionary *) dbData withObject:(id)myObj{
    id ob2 = [[[myObj class] alloc] init];
    
    NSArray *dataKeys = [dbData allKeys];
    for (int i = 0 ; i < [dataKeys count] ; i++) {
                ////NSLog(@"In For %@",[dataKeys objectAtIndex:i]);
        id obj = [dbData valueForKey:[dataKeys objectAtIndex:i]];
        
        
        @try
        {
            [ob2 setValue:obj forKey:[dataKeys objectAtIndex:i]];
        }
        @catch (NSException * e)
        {
            if ([[e name] isEqualToString:NSInvalidArgumentException])
            {
                NSNumber* boolVal = [NSNumber numberWithBool:[obj boolValue]];
                [ob2 setValue:boolVal forKey:[dataKeys objectAtIndex:i]];
            }
        }
        
        /*if ([[dbData valueForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNumber class]]) {
            if (strcmp([obj objCType], @encode(BOOL)) == 0) {
               
                [ob2 setValue:[NSNumber numberWithBool:[obj boolValue]] forKey:[dataKeys objectAtIndex:i]];
            }else
                [ob2 setValue:obj forKey:[dataKeys objectAtIndex:i]];
        }
        else
            [ob2 setValue:obj forKey:[dataKeys objectAtIndex:i]];*/
        
        		////NSLog(@"\n%@",obj);
        obj = nil;
    }
    return ob2;
}



+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject;
        /*if ([key isEqualToString:@"Merchant"]) {
            classObject = NSClassFromString(@"PMMerchantParams");
        }*/
        
        id object = [obj valueForKey:key];
        
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject:object];
            [dict setObject:subObj forKey:key];
        }
        else if([object isKindOfClass:[NSArray class]])
        {
            NSMutableArray *subObj = [NSMutableArray array];
            for (id o in object) {
                [subObj addObject:[self dictionaryWithPropertiesOfObject:o]];
            }
            [dict setObject:subObj forKey:key];
        }
        else
        {
            if(object){
                //object = [PMFunctions escapeString:object];
                [dict setObject:object forKey:key];
            }
        }
    }
    
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Email Validation
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - Check Device
+(BOOL)IsiPhoneDevice{
    // NSString *deviceType = [UIDevice currentDevice].model;
    BOOL iPhone;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        iPhone = YES;
    else iPhone = NO;
    return iPhone;
}

#pragma mark - About Link
+(void)openAboutLink
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sts.in"]];
}

#pragma mark - date Function
+ (NSString *)formatDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMM'-'dd'-'yyyy"];
  //[dateFormatter setDateFormat:@"EEE,MMMdd,yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
+(NSDate *)convertStringToDate:(NSString *)strDate///54321
{
    //NSString *dateStr = @"Tue, 25 May 2010 12:53:58 +0000"; //EE, d LLLL yyyy HH:mm:ss Z
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM'-'dd'-'yyyy"];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    //[dateFormat setDateFormat:@"EEE,MMMdd,yyyy"];
    NSDate *date = [dateFormat dateFromString:strDate];

    return date;
}

#pragma mark Time Function
+(int)stringTimeComponentSeprate:(NSString *)value{
    NSArray *arrTime = [value componentsSeparatedByString:@":"];
    int seconds = [[arrTime objectAtIndex:0] intValue]%60;
    int minutes = [[arrTime objectAtIndex:1] intValue]/60;
    int hours = [[arrTime objectAtIndex:2] intValue];
    return seconds+minutes+hours;
}

+(NSString *)integerTimeConvertString:(int)value{

    /*int hours = value / (60 * 60 * 24);
    value -= hours * (60 * 60 * 24);
    int minutes = value / (60 * 60);
    value -= hours * (60 * 60);
    int seconds = value / 60;*/
   
    
    /*int seconds = (value % 60);
    int minutes = (value % 3600) / 60;
    int hours = (value % 86400) / 3600;*/
    /*value = (value * 10) % 1000;
    int seconds = value / 100.0;
    int minutes = seconds / 60.0;
    int hours = minutes / 60.0;*/
    
    //old
    int seconds = (int) ((int)value % 60);
    int minutes = (int) ((int)value / 60) % 60;
    int hours = (int) (value / 3600);
    
    return [NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds];
}

#pragma mark - SHA1 Encryption
+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}


#pragma mark - Hex Color
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings+
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
