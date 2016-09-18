//
//  UserRegister.h
//  CarWash
//
//  Created by Payal Patel on 18/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol RegisterData
@end


@interface RegisterData : JSONModel
@property (nonatomic,strong) NSString<Optional> *email;
@property (nonatomic,strong) NSString<Optional> *email_id;
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger user_id;
@property (nonatomic,strong) NSString<Optional> *name;
@property (nonatomic,strong) NSString<Optional> *referal_code;
@property (nonatomic,strong) NSString<Optional> *session_key;
@property (nonatomic,strong) NSString<Optional> *mobile_no;
@end

@protocol UserResponse
@end

@interface UserResponse : JSONModel
@property (nonatomic) NSInteger code;
@property (nonatomic,strong) RegisterData<Optional> *data;
@property (nonatomic,strong) NSString *msg;
@end

@interface UserRegister : JSONModel
@property (nonatomic,strong) UserResponse<Optional> *response;

@end
