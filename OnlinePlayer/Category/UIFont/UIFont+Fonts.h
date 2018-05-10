//
//  UIFont+Fonts.h
//  DachangMerchantClient
//
//  Created by aidongsheng on 2017/10/17.
//  Copyright © 2017年 aidongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Fonts)

#pragma mark - Added font.

/**
 *  HYQiHei-BEJF font (added by plist).
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HYQiHeiWithFontSize:(CGFloat)size;

#pragma mark - System font.

/**
 *  AppleSDGothicNeo-Thin font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AppleSDGothicNeoThinWithFontSize:(CGFloat)size;

/**
 *  Avenir font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AvenirWithFontSize:(CGFloat)size;

/**
 *  Avenir-Light font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AvenirLightWithFontSize:(CGFloat)size;

/**
 *  Heiti SC font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HeitiSCWithFontSize:(CGFloat)size;

/**
 *  HelveticaNeue font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HelveticaNeueFontSize:(CGFloat)size;

/**
 *  HelveticaNeue-Bold font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HelveticaNeueBoldFontSize:(CGFloat)size;

/**
 PingFangSC-Ultralight

 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCUltralightFontSize:(CGFloat)size;

/**
 PingFangSC-Light
 
 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCLightFontSize:(CGFloat)size;

/**
 PingFangSC-Thin
 
 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCThinFontSize:(CGFloat)size;

/**
 PingFangSC-Regular
 
 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCRegularFontSize:(CGFloat)size;

/**
 PingFangSC-Medium
 
 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCMediumFontSize:(CGFloat)size;

/**
 PingFangSC-Semibold
 
 @param size Font's size
 @return Font
 */
+ (UIFont *)PingFangSCSemiboldFontSize:(CGFloat)size;

@end
