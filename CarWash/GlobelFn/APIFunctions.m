//
//  APIFunctions.m
//  CarWash
//
//  Created by Payal Patel on 11/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "APIFunctions.h"


#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Timeout.h"



#define sha1Key @"@BCD"
#define Url @"http://carflusher.com/api/appApi/api?method="

//http://carflusher.com/api/appApi/api?method=checkSession&key=ae0dc132fe5e684fa06d12047b597184acaaaefa&session_key=xxxx
//http:/carflusher.com/api/appApi/api?method=checkSession&key=ae0dc132fe5e684fa06d12047b597184acaaaefa&session_key=xxx
#define checkSession @"checkSession"

//http://carflusher.com/api/appApi/api?method=registration&key=b237eef2e56a018d0cf46f7749a5f0ceca9e4529&name=Rohan Kadam&email_id=rohank989@gmail.com&mobile_no=8108017849&password=Rohan@123&otp=1234
#define userRegister @"registration"

//http://carflusher.com/api/appApi/api?method=generateOtp&key=74bbb7de2e901fb44967796af37a00b48c429f4e&mobile_no=8108017849
#define GetOTP @"generateOtp"


//http://carflusher.com/api/appApi/api?method=userLogin&key=1a3a2d1f306d3adbc4ed6742a051ccada891c058&username=8108017849&password=Rohan@123
#define login @"userLogin"



/*[APIFunctions registerUserApi:^(id resObject) {
 } failure:^(NSDictionary *error){
 }];*/


/*
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.requestSerializer.timeoutInterval = 120;
 manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
 NSString *key = [Functions sha1:String(@"%@%@",userRegister,sha1Key)];
 
 NSLog(@"%@",key);
 
 [manager GET:@"" parameters:nil timeoutInterval:120.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 NSLog(@"JSON: %@", responseObject);
 success(responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"operation.responseString %@",operation.responseString);
 NSLog(@"Error: %@", error);
 failure(@{@"Code":String(@"%d",error.code),@"message":error.description});
 }];
 */

@implementation APIFunctions

+(void)checkSessionApi:(NSString *)session success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 120;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *key = [Functions sha1:String(@"%@%@",checkSession,sha1Key)];
    
    NSString *url = String(@"%@%@",Url,checkSession);
    NSLog(@"%@",url);
    NSDictionary *dic = @{@"key":key,@"session_key":session};
    [manager GET:url parameters:dic timeoutInterval:120.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation.responseString %@",operation.responseString);
        NSLog(@"Error: %@", error);
        failure(@{@"Code":String(@"%d",error.code),@"message":error.description});
    }];
}

+(void)genrateOTP:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 120;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *key = [Functions sha1:String(@"%@%@",GetOTP,sha1Key)];
    
    NSLog(@"%@",key);
    NSString *url = String(@"%@%@",Url,GetOTP);
    NSDictionary *dic = @{@"key":key,@"mobile_no":mobile};
    [manager GET:url parameters:dic timeoutInterval:120.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation.responseString %@",operation.responseString);
        NSLog(@"Error: %@", error);
        failure(@{@"Code":String(@"%d",error.code),@"message":error.description});
    }];
}
+(void)registerUserApiMo:(NSString *)mobile name:(NSString *)name emailId:(NSString *)email password:(NSString *)pwd OTP:(NSString *)otp success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 120;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *key = [Functions sha1:String(@"%@%@",userRegister,sha1Key)];
    
    NSLog(@"%@",key);
    NSString *url = String(@"%@%@",Url,userRegister);
    //NSString *url = String(@"%@%@&key=%@&name=%@&email_id=%@&mobile_no=%@&password=%@&otp=%@",Url,userRegister,key,name,email,mobile,pwd,otp);
    //NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"key":key,@"name":name,@"email_id":email,@"mobile_no":mobile,@"password":pwd,@"otp":otp};
    
    [manager GET:url parameters:dic timeoutInterval:120.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation.responseString %@",operation.responseString);
        NSLog(@"Error: %@", error);
        failure(@{@"Code":String(@"%d",error.code),@"message":error.description});
    }];
    
}

+(void)loginUserAPIMo:(NSString *)mobile pwd:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSDictionary *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 120;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *key = [Functions sha1:String(@"%@%@",login,sha1Key)];
    
    NSString *url = String(@"%@%@",Url,login);
    NSLog(@"%@",url);
    NSDictionary *dic = @{@"key":key,@"username":mobile,@"password":pwd};
    [manager GET:url parameters:dic timeoutInterval:120.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation.responseString %@",operation.responseString);
        NSLog(@"Error: %@", error);
        failure(@{@"Code":String(@"%d",error.code),@"message":error.description});
    }];
}

@end
