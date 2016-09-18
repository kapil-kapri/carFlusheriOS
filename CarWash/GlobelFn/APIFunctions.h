//
//  APIFunctions.h
//  CarWash
//
//  Created by Payal Patel on 11/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface APIFunctions : NSObject

+(void)checkSessionApi:(NSString *)session success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure;
+(void)registerUserApiMo:(NSString *)mobile name:(NSString *)name emailId:(NSString *)email password:(NSString *)pwd OTP:(NSString *)otp success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure;
+(void)genrateOTP:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure;
+(void)loginUserAPIMo:(NSString *)mobile pwd:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure;

@end
