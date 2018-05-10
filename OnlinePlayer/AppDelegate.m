//
//  AppDelegate.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/9.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]init];
    _window.frame = [UIScreen mainScreen].bounds;
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    _window.rootViewController = homeVC;
    homeVC.view.backgroundColor = [UIColor orangeColor];
    [_window makeKeyAndVisible];
    return YES;
}

@end
