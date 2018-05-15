//
//  NetworkStatusHelper.h
//  OnlinePlayer
//
//  Created by josan on 2018/5/15.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkStatusHelper : NSObject

/**
 监测网络变化

 @param block 网络变化回调函数
 */
+ (void)startMonitorNetworkStatus:(nullable void (^)(AFNetworkReachabilityStatus status))block;
+ (void)stopMonitorNetworkStatus;

@end
