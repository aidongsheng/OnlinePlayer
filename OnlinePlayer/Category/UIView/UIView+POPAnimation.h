//
//  UIView+POPAnimation.h
//  tools
//
//  Created by wcc on 2018/4/8.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, wccCountType) {
    wccCountTypeCountDown,
    wccCountTypeDigitalClock,
    wccCountTypeFloatNumber,
};

@interface UIView (POPAnimation)

/**
 为 UIView 的 XY 轴添加缩放动画

 @param scale 缩放系数
 @param duration 动画时长
 @param reverse 是否自动返回
 */
- (void)wcc_addScaleXYAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 为 UIView 的 X 轴方向添加缩放动画

 @param scale 缩放系数
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addScaleXAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 为 UIView 的 Y 轴方向添加缩放动画

 @param rotation 缩放系数
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addScaleYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse;
/**
 为 UIView 添加旋转动画

 @param rotation 旋转度数
 @param duration 动画时长
 @param reverse 是否自动返回
 */
- (void)wcc_addRotationXYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 为 UIView 的 X 轴添加旋转动画

 @param rotation 旋转弧度
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addRotationXAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 为 UIView 的 Y 轴添加旋转动画

 @param rotation 旋转弧度
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addRotationYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse;


/**
 添加到达某点动画

 @param point 目的 point
 @param deceleration 减速系数
 */

/**
 添加图片中心位置动画

 @param point UIView 中心位置
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addViewCenterAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 添加背景颜色过渡动画

 @param backgroundColor 目的背景颜色
 @param duration 过渡周期
 @param reverse 是否自动返回
 */
- (void)wcc_addBackgroundColorAnimation:(UIColor *)backgroundColor duration:(CGFloat)duration autoReverse:(BOOL)reverse;


/**
 数字动画

 @param destValue 目的数字
 @param duration 动画周期
 @param reverse 是否自动返回
 @param type 模拟计数类型
 */
- (void)wcc_addCountDownAnimation:(CGFloat)destValue duration:(CGFloat)duration autoReverse:(BOOL)reverse simulateType:(wccCountType)type;


/**
 添加 frame 改变动画

 @param frame 目的 frame
 */

/**
frame 改变动画

 @param frame 目的frame
 @param duration 动画过渡周期
 @param reverse 是否自动返回
 */
- (void)wcc_addFrameAnimation:(CGRect)frame duration:(CGFloat)duration autoReverse:(BOOL)reverse;

/**
 改变 view 大小动画

 @param size 目的 size
 */
- (void)wcc_addSizeAnimation:(CGSize)size;

/**
 透明度动画

 @param alpha 目的透明度
 @param duration 动画周期
 @param reverse 是否自动返回
 */
- (void)wcc_addAlphaAnimation:(CGFloat)alpha duration:(CGFloat)duration autoReverse:(BOOL)reverse;

- (void)wcc_addTranslationXYAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse;

- (void)wcc_addPositionXAnimation;

/**
 添加圆角动画
 */
- (void)wcc_addCornerRadiusAnimation;


/**
 为标签添加颜色过渡动画

 @param labelTextColor 目的颜色
 @param duration 过渡周期
 @param reverse 是否自动返回
 */
- (void)wcc_addLabelTextColorAnimation:(UIColor *)labelTextColor duration:(CGFloat)duration autoReverse:(BOOL)reverse;


/**
 添加边框闪烁动画

 @param color 目的颜色
 @param duration 过渡时间
 @param reverse 是否自动返回
 */
- (void)wcc_addBorderBlinkAnimation:(UIColor *)color duration:(CGFloat)duration autoReverse:(BOOL)reverse;


/**
 左右晃动动画

 @param offset 晃动幅度
 */
- (void)wcc_addShakeAnimationWithOffset:(CGFloat)offset;
@end
