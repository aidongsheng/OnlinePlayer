//
//  NetworkStatusHelper.m
//  OnlinePlayer
//
//  Created by josan on 2018/5/15.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "NetworkStatusHelper.h"

@implementation NetworkStatusHelper

+ (void)startMonitorNetworkStatus:(nullable void (^)(AFNetworkReachabilityStatus status))block
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:block];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitorNetworkStatus
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
