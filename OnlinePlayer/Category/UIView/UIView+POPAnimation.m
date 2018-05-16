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
#define wccCountDownAnimationKey        @"wccCountDownAnimationKey"

- (void)wcc_addScaleXYAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.delegate = self;
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleAnimation.autoreverses = reverse;
    scaleAnimation.springBounciness = 100;
    scaleAnimation.springSpeed = 200;
    scaleAnimation.dynamicsMass = 2;
    scaleAnimation.dynamicsFriction = 15;
    scaleAnimation.dynamicsTension = 200;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self.layer pop_removeAnimationForKey:kPOPLayerScaleXY];
        }
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:kPOPLayerScaleXY];
}

- (void)wcc_addScaleXAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPViewScaleX];
    POPBasicAnimation *scaleXAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleX];
    scaleXAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, 1)];
    scaleXAnimation.duration = duration;
    scaleXAnimation.autoreverses = reverse;
    [self pop_addAnimation:scaleXAnimation forKey:kPOPViewScaleX];
}

- (void)wcc_addScaleYAnimation:(CGFloat)scale duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPViewScaleY];
    POPBasicAnimation *scaleYAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleY];
    scaleYAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, scale)];
    scaleYAnimation.duration = duration;
    scaleYAnimation.autoreverses = reverse;
    [self pop_addAnimation:scaleYAnimation forKey:kPOPViewScaleY];
}

- (void)wcc_addRotationXYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPLayerRotation];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    [self.layer pop_addAnimation:rotationAnimation forKey:kPOPLayerRotation];
}
- (void)wcc_addRotationXAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPLayerRotationX];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationX];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    [self.layer pop_addAnimation:rotationAnimation forKey:kPOPLayerRotationX];
}
- (void)wcc_addRotationYAnimation:(CGFloat)rotation duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    
    [self.layer pop_removeAnimationForKey:kPOPLayerRotationY];
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    rotationAnimation.toValue = @(rotation);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = reverse;
    rotationAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self.layer pop_removeAnimationForKey:kPOPLayerRotationY];
        }
    };
    [self.layer pop_addAnimation:rotationAnimation forKey:kPOPLayerRotationY];
}
- (void)wcc_addViewCenterAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    
    [self pop_removeAnimationForKey:kPOPViewCenter];
    POPBasicAnimation *centerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x - self.frame.size.width/2, point.y - self.frame.size.height/2)];
    centerAnim.duration = duration;
    centerAnim.autoreverses = reverse;
    [self pop_addAnimation:centerAnim forKey:kPOPViewCenter];
}

- (void)wcc_addBackgroundColorAnimation:(UIColor *)backgroundColor duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPLayerBackgroundColor];
    POPBasicAnimation * backgroundColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    backgroundColorAnim.toValue = backgroundColor;
    backgroundColorAnim.duration = duration;
    backgroundColorAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:backgroundColorAnim forKey:kPOPLayerBackgroundColor];
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
    [self pop_removeAnimationForKey:kPOPViewFrame];
    POPBasicAnimation *frameAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnim.toValue = [NSValue valueWithCGRect:frame];
    frameAnim.duration = duration;
    frameAnim.autoreverses = reverse;
    CAMediaTimingFunction * func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    frameAnim.timingFunction = func;
    frameAnim.delegate = self;
    [self pop_addAnimation:frameAnim forKey:kPOPViewFrame];
}

- (void)wcc_addSizeAnimation:(CGSize)size
{
    [self pop_removeAnimationForKey:kPOPViewSize];
    POPSpringAnimation *sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnim.velocity = [NSValue valueWithCGSize:size];
    [self pop_addAnimation:sizeAnim forKey:kPOPViewSize];
}

- (void)wcc_addAlphaAnimation:(CGFloat)alpha duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPLayerOpacity];
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnim.toValue = @(alpha);
    alphaAnim.duration = duration;
    alphaAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:alphaAnim forKey:kPOPLayerOpacity];
}

- (void)wcc_addTranslationXYAnimation:(CGPoint)point duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self pop_removeAnimationForKey:kPOPLayerTranslationXY];
    POPBasicAnimation *translationXYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationXY];
    translationXYAnim.toValue = [NSValue valueWithCGPoint:point];
    translationXYAnim.duration = duration;
    translationXYAnim.autoreverses = reverse;
    [self.layer pop_addAnimation:translationXYAnim forKey:kPOPLayerTranslationXY];
}

- (void)wcc_addPositionXAnimation
{
    [self.layer pop_removeAnimationForKey:kPOPLayerPositionX];
    POPSpringAnimation *positionXAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionXAnim.springBounciness = 10;
    positionXAnim.dynamicsTension = 1000;
    positionXAnim.dynamicsFriction = 10;
    positionXAnim.velocity = @50;
    [self.layer pop_addAnimation:positionXAnim forKey:kPOPLayerPositionX];
}


- (void)wcc_addCornerRadiusAnimation
{
    [self.layer pop_removeAnimationForKey:kPOPLayerCornerRadius];
    POPSpringAnimation * cornerRadius = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerRadius.fromValue = @0;
    cornerRadius.velocity = @1;
    CGFloat maxSize = self.frame.size.height > self.frame.size.width ? self.frame.size.width : self.frame.size.height;
    cornerRadius.toValue = @(maxSize/2);
    cornerRadius.springBounciness = 22.0f;
    [self.layer pop_addAnimation:cornerRadius forKey:kPOPLayerCornerRadius];
}

- (void)wcc_addLabelTextColorAnimation:(UIColor *)labelTextColor duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self pop_removeAnimationForKey:kPOPLabelTextColor];
    if ([self isKindOfClass:[UILabel class]]) {
        POPBasicAnimation * labelTextColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        labelTextColorAnimation.duration = duration;
        labelTextColorAnimation.autoreverses = reverse;
        labelTextColorAnimation.toValue = labelTextColor;
        [self pop_addAnimation:labelTextColorAnimation forKey:kPOPLabelTextColor];
    }else{
        NSLog(@"此视图非 UILabel，不可添加 UILabel 文字颜色动画");
    }
}


- (void)wcc_addTableViewAnimationWithContentOffset:(CGPoint)contentOffset
{
    [self pop_removeAnimationForKey:kPOPTableViewContentOffset];
    POPSpringAnimation * tableViewOffsetAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPTableViewContentOffset];
    tableViewOffsetAnimation.toValue = [NSValue valueWithCGPoint:contentOffset];
    [self pop_addAnimation:tableViewOffsetAnimation forKey:kPOPTableViewContentOffset];
}

- (void)wcc_addBorderBlinkAnimation:(UIColor *)color duration:(CGFloat)duration autoReverse:(BOOL)reverse
{
    [self.layer pop_removeAnimationForKey:kPOPLayerBorderColor];
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
    [self.layer pop_addAnimation:BlinkAnimation forKey:kPOPLayerBorderColor];
}

- (void)wcc_addShakeAnimationWithOffset:(CGFloat)offset
{
    [self.layer pop_removeAnimationForKey:kPOPLayerTranslationX];
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
    [self.layer pop_addAnimation:shakeAnimationTranslationX forKey:kPOPLayerTranslationX];
}

@end
