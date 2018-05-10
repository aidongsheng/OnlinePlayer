//
//  UIViewController+DefaultView.h
//  demo
//
//  Created by wcc on 2018/4/11.
//  Copyright © 2018年 wcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DefaultView)

- (void)showLoadingView;
- (void)hideLoadingView;
- (void)showNetworkErrorView;
- (void)hideNetworkErrorView;

@end
