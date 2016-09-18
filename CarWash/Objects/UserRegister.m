//
//  UserRegister.m
//  CarWash
//
//  Created by Payal Patel on 18/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "UserRegister.h"

@implementation RegisterData

//Ignore int or boolean value
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"id"])
        return YES;
    if ([propertyName isEqualToString:@"user_id"])
        return YES;
    
    return NO;
}

@end

@implementation UserResponse


@end

@implementation UserRegister

@end
