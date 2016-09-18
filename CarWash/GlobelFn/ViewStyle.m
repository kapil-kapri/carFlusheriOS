//
//  ViewStyle.m
//  Shooting App
//
//  Created by Payal Patel on 18/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import "ViewStyle.h"
#import "Functions.h"

@implementation ViewStyle
@synthesize backgroundColor;
@synthesize inputFieldBackgroundColor;
@synthesize inputFieldTextColor;
@synthesize inputFieldPlaceholderColor;
@synthesize inputFieldWrongColor;
@synthesize buttonBackgroundColor;
@synthesize buttonTitleColor;
@synthesize axisValueColor;
@synthesize graphBackgroundcolor;
@synthesize graphBackGroungLines;
@synthesize axisToolTipColor;
@synthesize axisNameColour;


-(id)init{
    self = [super init];
    if (self) {
        
        backgroundColor = [UIColor blackColor];
        inputFieldBackgroundColor = [UIColor whiteColor];
        inputFieldTextColor = [UIColor blackColor];
        inputFieldPlaceholderColor = [UIColor grayColor];
        inputFieldWrongColor = [UIColor redColor];
        buttonBackgroundColor = [Functions colorWithHexString:@"EA8175"];
        axisValueColor = [Functions colorWithHexString:@"FFDCB8"];
        graphBackgroundcolor = [Functions colorWithHexString:@"191919"];
        graphBackGroungLines = [Functions colorWithHexString:@"#343434"];
        axisToolTipColor = [Functions colorWithHexString:@"EA9E23"];
        axisNameColour = [Functions colorWithHexString:@"444444"];
        buttonTitleColor = [UIColor whiteColor];
    }
    return self;
}
-(UIFont *)regularFont:(float)size
{
    return [UIFont fontWithName:@"OpenSans" size:size];//[UIFont systemFontOfSize:size];
}

-(UIFont *)boldFont:(float)size
{
    return [UIFont fontWithName:@"OpenSans" size:size];//[UIFont boldSystemFontOfSize:size];
}

@end
