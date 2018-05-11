//
//  UIView+Additions.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "UIView+Additions.h"


@implementation UIView (Additions)

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX, self.originY, self.width, self.height);
}

- (void)setOriginY:(CGFloat)originY
{
    self.frame = CGRectMake(self.originX, originY, self.width, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.originX, self.originY, width, self.height);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.originX, self.originY, self.width, height);
}

- (UIImage *)ads_snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    return snapshot;
}

- (UIViewController *)visibleViewController
{
    for (UIView *view = self; view;view = view.superview) {
        id viewController = [view nextResponder];
        if ([viewController isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)viewController;
        }
    }
    return nil;
}
@end
