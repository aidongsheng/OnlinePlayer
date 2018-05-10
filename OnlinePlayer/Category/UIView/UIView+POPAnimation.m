//
//  UIView+POPAnimation.m
//  tools
//
//  Created by wcc on 2018/4/8.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "UIView+POPAnimation.h"
#import <POP.h>

@interface UIView()<POPAnimationDelegate>

@end

@implementation UIView (POPAnimation)

/***    pop 动画 key 值    ***/
#define wccScaleXYAnimationKey          @"wccScaleXYAnimationKey"
#define wccScaleXAnimationKey           @"wccScaleXAnimationKey"
#define wccScaleYAnimationKey           @"wccScaleYAnimationKey"
#define wccRotationXYAnimationKey       @"wccRotationXYAnimationKey"
#define wccRotationXAnimationKey        @"wccRotationXAnimationKey"
#define wccRotationYAnimationKey        @"wccRotationYAnimationKey"
#define wccViewCenterAnimationKey          @"wccViewCenterAnimationKey"
#define wccViewBackgroundColorKey       @"wccViewBackgroundColorKey"
#define wccCountDownAnimationKey        @"wccCountDownAnimationKey"
#define wccFrameAnimationKey            @"wccFrameAnimationKey"
#define wccSizeAnimationKey             @"wccSizeAnimationKey"
#define wccAlphaAnimationKey            @"wccAlphaAnimationKey"
#define wccTranslationXYAnimationKey    @"wccTranslationXYAnimationKey"
#define wccPositionAnimationXKey        @"wccPositionAnimationXKey"
#define wccCornerRadiusAnimationKey     @"wccCornerRadiusAnimationKey"
#define wccLabelTextColorAnimationKey      @"wccLabelTextColorAnimationKey"
#define wccTableViewAnimationWithContentOffset  @"wccTableViewAnimationWithContentOffset"
#define wccBorderBlinkAnimationKey      @"wccBorderBlinkAnimationKey"
#define wccShakeAnimationWithOffsetKey  @"ShakeAnimationWithOffsetKey"

- (void)wcc_addScaleXYAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccScaleXYAnimationKey];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleAnimation.autoreverses = reverse;
    scaleAnimation.springBounciness = 100;
    scaleAnimation.springSpeed = 200;
    scaleAnimation.dynamicsMass = 2;
    scaleAnimation.dynamicsFriction = 15;
    scaleAnimation.dynamicsTension = 200;
    [self.layer pop_addAnimation:scaleAnimation forKey:wccScaleXYAnimationKey];
}

- (void)wcc_addScaleXAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccScaleXAnimationKey];
    POPBasicAnimation *scaleXAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleX];
    scaleXAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleXAnimation.duration = duration;
    scaleXAnimation.autoreverses = reverse;
    [self pop_addAnimation:scaleXAnimation forKey:wccScaleXAnimationKey];
}

- (void)wcc_addScaleYAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccScaleYAnimationKey];
    POPBasicAnimation *scaleYAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleX];
    scaleYAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleYAnimation.duration = duration;
    scaleYAnimation.autoreverses = reverse;
    [self pop_addAnimation:scaleYAnimation forKey:wccScaleYAnimationKey];
}

- (void)wcc_addRotationXYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccRotationXYAnimationKey];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    [self.layer pop_addAnimation:rotationAnimation forKey:wccRotationXYAnimationKey];
}
- (void)wcc_addRotationXAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccRotationXAnimationKey];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    [self.layer pop_addAnimation:rotationAnimation forKey:wccRotationXAnimationKey];
}
- (void)wcc_addRotationYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccRotationYAnimationKey];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    [self.layer pop_addAnimation:rotationAnimation forKey:wccRotationYAnimationKey];
}
- (void)wcc_addViewCenterAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    
    [self pop_removeAnimationForKey:wccViewCenterAnimationKey];
    POPBasicAnimation *centerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x - self.frame.size.width/2, point.y - self.frame.size.height/2)];
    centerAnim.duration = duration;
    centerAnim.autoreverses = reverse;
    [self pop_addAnimation:centerAnim forKey:wccViewCenterAnimationKey];
}

- (void)wcc_addBackgroundColorAnimation:(UIColor *)backgroundColor duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccViewBackgroundColorKey];
    POPBasicAnimation * backgroundColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    backgroundColorAnim.toValue = backgroundColor;
    backgroundColorAnim.duration = duration;
    backgroundColorAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:backgroundColorAnim forKey:wccViewBackgroundColorKey];
}

- (void)wcc_addCountDownAnimation:(CGFloat)destValue duration:(CGFloat)duration autoReverse:(BOOL)reverse simulateType:(wccCountType)type
{
    [self pop_removeAnimationForKey:wccCountDownAnimationKey];
    POPBasicAnimation *countDownAnim = [POPBasicAnimation animation];
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countDown" initializer:^(POPMutableAnimatableProperty *prop) {
        
        if (type == wccCountTypeCountDown) {
            
        }else if (type == wccCountTypeDigitalClock){
            
        }else if (type == wccCountTypeFloatNumber){
            
        }
        prop.readBlock = ^(id obj, CGFloat *values) {
            values[0] = [[obj description] floatValue];
        };
        prop.writeBlock = ^(id obj, const CGFloat *values) {
            UILabel * label = obj;
            [label setText:[NSString stringWithFormat:@"%.0f",values[0]]];
        };
        
    }];
    countDownAnim.property = prop;
    countDownAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    countDownAnim.toValue = @(destValue);
    countDownAnim.duration = duration;
    countDownAnim.autoreverses = reverse;
    [self pop_addAnimation:countDownAnim forKey:wccCountDownAnimationKey];
}

- (void)wcc_addFrameAnimation:(CGRect)frame duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self pop_removeAnimationForKey:wccFrameAnimationKey];
    POPBasicAnimation *frameAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnim.toValue = [NSValue valueWithCGRect:frame];
    frameAnim.duration = duration;
    frameAnim.autoreverses = reverse;
    CAMediaTimingFunction * func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    frameAnim.timingFunction = func;
    frameAnim.delegate = self;
    [self pop_addAnimation:frameAnim forKey:wccFrameAnimationKey];
}

- (void)wcc_addSizeAnimation:(CGSize)size
{
    [self pop_removeAnimationForKey:wccSizeAnimationKey];
    POPSpringAnimation *sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnim.velocity = [NSValue valueWithCGSize:size];
    [self pop_addAnimation:sizeAnim forKey:wccSizeAnimationKey];
}

- (void)wcc_addAlphaAnimation:(CGFloat)alpha duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccAlphaAnimationKey];
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnim.toValue = @(alpha);
    alphaAnim.duration = duration;
    alphaAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:alphaAnim forKey:wccAlphaAnimationKey];
}

- (void)wcc_addTranslationXYAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self pop_removeAnimationForKey:wccTranslationXYAnimationKey];
    POPBasicAnimation *translationXYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationXY];
    translationXYAnim.toValue = [NSValue valueWithCGPoint:point];
    translationXYAnim.duration = duration;
    translationXYAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:translationXYAnim forKey:wccTranslationXYAnimationKey];
}

- (void)wcc_addPositionXAnimation
{
    [self.layer pop_removeAnimationForKey:wccPositionAnimationXKey];
    POPSpringAnimation *positionXAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionXAnim.springBounciness = 10;
    positionXAnim.dynamicsTension = 1000;
    positionXAnim.dynamicsFriction = 10;
    positionXAnim.velocity = @50;
    [self.layer pop_addAnimation:positionXAnim forKey:wccPositionAnimationXKey];
}


- (void)wcc_addCornerRadiusAnimation
{
    [self.layer pop_removeAnimationForKey:wccCornerRadiusAnimationKey];
    POPSpringAnimation * cornerRadius = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerRadius.fromValue = @0;
    cornerRadius.velocity = @1;
    CGFloat maxSize = self.frame.size.height > self.frame.size.width ? self.frame.size.width : self.frame.size.height;
    cornerRadius.toValue = @(maxSize/2);
    cornerRadius.springBounciness = 22.0f;
    [self.layer pop_addAnimation:cornerRadius forKey:wccCornerRadiusAnimationKey];
}

- (void)wcc_addLabelTextColorAnimation:(UIColor *)labelTextColor duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self pop_removeAnimationForKey:wccLabelTextColorAnimationKey];
    if ([self isKindOfClass:[UILabel class]]) {
        POPBasicAnimation * labelTextColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        labelTextColorAnimation.duration = duration;
        labelTextColorAnimation.autoreverses = reverse;
        labelTextColorAnimation.toValue = labelTextColor;
        [self pop_addAnimation:labelTextColorAnimation forKey:wccLabelTextColorAnimationKey];
    }else{
        NSLog(@"此视图非 UILabel，不可添加 UILabel 文字颜色动画");
    }
}


- (void)wcc_addTableViewAnimationWithContentOffset:(CGPoint)contentOffset
{
    [self pop_removeAnimationForKey:wccTableViewAnimationWithContentOffset];
    POPSpringAnimation * tableViewOffsetAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPTableViewContentOffset];
    tableViewOffsetAnimation.toValue = [NSValue valueWithCGPoint:contentOffset];
    [self pop_addAnimation:tableViewOffsetAnimation forKey:wccTableViewAnimationWithContentOffset];
}

- (void)wcc_addBorderBlinkAnimation:(UIColor *)color duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:wccBorderBlinkAnimationKey];
    POPBasicAnimation * BlinkAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
    self.layer.borderWidth = 1;
    BlinkAnimation.duration = duration;
    BlinkAnimation.toValue = color;
    BlinkAnimation.autoreverses = reverse;
    BlinkAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
        }
    };
    [self.layer pop_addAnimation:BlinkAnimation forKey:wccBorderBlinkAnimationKey];
}

- (void)wcc_addShakeAnimationWithOffset:(CGFloat)offset
{
    [self.layer pop_removeAnimationForKey:wccShakeAnimationWithOffsetKey];
    POPSpringAnimation * shakeAnimationTranslationX = [POPSpringAnimation animationWithCustomPropertyNamed:kPOPLayerTranslationX readBlock:^(id obj, CGFloat *values) {
        
    } writeBlock:^(id obj, const CGFloat *values) {
        
    }];
    shakeAnimationTranslationX.velocity = @200;
    shakeAnimationTranslationX.springSpeed = 200;
    shakeAnimationTranslationX.springBounciness = 400;
    shakeAnimationTranslationX.fromValue = @(offset);
    shakeAnimationTranslationX.toValue = @0;
    shakeAnimationTranslationX.dynamicsTension = 10000;
    shakeAnimationTranslationX.dynamicsMass = 20;
    shakeAnimationTranslationX.dynamicsFriction = 100;
    [self.layer pop_addAnimation:shakeAnimationTranslationX forKey:wccShakeAnimationWithOffsetKey];
}


@end
