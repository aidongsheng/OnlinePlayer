//
//  UIColor+ADSAdd.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/11.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "UIColor+ADSAdd.h"

@implementation UIColor (ADSAdd)
+ (UIColor *)colorWithHex:(NSString *)hex
{
    if ([hex isValidHex]) {
        if ([hex hasPrefix:@"0x"]) {
            hex = [hex substringFromIndex:2];
        }
        
        int *rgbValue = [hex hexToDecimal];
        if (rgbValue != NULL) {
            UIColor *color = nil;
            if (hex.length == 6) {
                int rValue = rgbValue[0];
                int gValue = rgbValue[1];
                int bValue = rgbValue[2];
                double red = rValue/255.0;
                double green = gValue/255.0;
                double blue = bValue/255.0;
                color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
                
            }
            return color;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
+ (UIColor *)randomColor
{
    NSInteger maxRGB = [@"FFFFFF" hexToInt];
    return [UIColor colorWithRGB:arc4random()%maxRGB];
}
@end
