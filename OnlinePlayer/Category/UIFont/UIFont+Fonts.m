//
//  UIFont+Fonts.m
//  DachangMerchantClient
//
//  Created by aidongsheng on 2017/10/17.
//  Copyright © 2017年 aidongsheng. All rights reserved.
//

#import "UIFont+Fonts.h"

@implementation UIFont (Fonts)

#pragma mark - Added font.

+ (UIFont *)HYQiHeiWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HYQiHei-BEJF" size:size];
}

#pragma mark - System font.

+ (UIFont *)AppleSDGothicNeoThinWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:size];
}

+ (UIFont *)AvenirWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Avenir" size:size];
}

+ (UIFont *)AvenirLightWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Avenir-Light" size:size];
}

+ (UIFont *)HeitiSCWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Heiti SC" size:size];
}

+ (UIFont *)HelveticaNeueFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)HelveticaNeueBoldFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

#pragma mark - PingfangSC

+ (UIFont *)PingFangSCUltralightFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
}

+ (UIFont *)PingFangSCThinFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
}

+ (UIFont *)PingFangSCLightFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+ (UIFont *)PingFangSCRegularFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)PingFangSCMediumFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)PingFangSCSemiboldFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

@end
