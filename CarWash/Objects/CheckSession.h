//
//  CheckSession.h
//  CarWash
//
//  Created by Payal Patel on 18/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol SessionData
@end

@interface SessionData : JSONModel
@property (nonatomic,strong) NSString<Optional> *is_valid_session;
@property (nonatomic,strong) NSString<Optional> *update_required;
@end

@protocol SessionResponse
@end

@interface SessionResponse : JSONModel
@property (nonatomic) NSInteger code;
@property (nonatomic,strong) SessionData<Optional> *data;
@property (nonatomic,strong) NSString *msg;
@end

@interface CheckSession : JSONModel
@property (nonatomic,strong) SessionResponse<Optional> *response;

@end
