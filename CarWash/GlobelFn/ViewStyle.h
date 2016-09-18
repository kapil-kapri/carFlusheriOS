//
//  ViewStyle.h
//  Shooting App
//
//  Created by Payal Patel on 18/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ViewStyle : NSObject
/**
 backgroundColor
 */
@property (nonatomic) UIColor *backgroundColor;
/**
 inputFieldBackgroundColor
 */
@property (nonatomic) UIColor *inputFieldBackgroundColor;
/**
 inputFieldTextColor
 */
@property (nonatomic) UIColor *inputFieldTextColor;
/**
 inputFieldPlaceholderColor
 */
@property (nonatomic) UIColor *inputFieldPlaceholderColor;
/**
 inputFieldWrongColor
 */
@property (nonatomic) UIColor *inputFieldWrongColor;
/**
 buttonBackgroundColor
 */
@property (nonatomic) UIColor *buttonBackgroundColor;
/**
 buttonTitleColor
 */
@property (nonatomic) UIColor *buttonTitleColor;
/**
graphAxisColor
 */
@property (nonatomic) UIColor *graphBackGroungLines;
/**
 axisValueColor
 */
@property (nonatomic) UIColor *axisValueColor;
/**
graphBackgroundColor
 */
@property (nonatomic) UIColor *graphBackgroundcolor;
/**
statisticsBackgroundColor
 */
@property (nonatomic) UIColor *axisNameColour;
/**
toolTipColor
 */
@property (nonatomic) UIColor *axisToolTipColor;
/**
 Font Method
 */
-(UIFont *)regularFont:(float)size;
-(UIFont *)boldFont:(float)size;

@end
