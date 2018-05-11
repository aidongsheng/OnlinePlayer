//
//  UIView+Additions.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;


/**
 获取截屏图片

 @return 截屏图片
 */
- (UIImage *)ads_snapshotImage;

/**
 获取当前控制器

 @return 当前视图所属控制器对象
 */
- (UIViewController *)visibleViewController;
@end
