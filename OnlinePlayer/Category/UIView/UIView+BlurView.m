//
//  UIView+BlurView.m
//  tools
//
//  Created by wcc on 2018/4/11.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "UIView+BlurView.h"

@implementation UIView (BlurView)
- (void)wcc_addBlurView
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.alpha = 0.75;
    visualEffectView.frame = self.bounds;
    [self addSubview:visualEffectView];
}
@end
