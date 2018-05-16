//
//  UIView+Additions.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "UIView+Additions.h"


typedef NS_ENUM(NSUInteger, AlertType) {
    AlertTypeSuccess,
    AlertTypeFailure,
    AlertTypeText,
};

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

- (void)showSuccessMsg:(NSString *)msg
{
    [self showMsg:msg alertType:AlertTypeSuccess];
}

- (void)showFailureMsg:(NSString *)msg
{
    [self showMsg:msg alertType:AlertTypeFailure];
}
- (void)showMsg:(NSString *)msg
{
    [self showMsg:msg alertType:AlertTypeText];
}
- (void)showMsg:(NSString *)msg alertType:(AlertType)type
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view
                                                     animated:YES];
    hud.label.text = msg;
    hud.label.font = [UIFont HeitiSCWithFontSize:15];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    if (AlertTypeSuccess == type) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_icon"]];
        hud.customView = customView;
    }else if (AlertTypeFailure == type) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error_icon"]];
        hud.customView = customView;
    }else if (AlertTypeText == type) {
        hud.mode = MBProgressHUDModeText;
    }
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1];
    
    
}
@end
