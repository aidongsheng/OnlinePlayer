//
//  OnlinePlayerMacro.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#ifndef OnlinePlayerMacro_h
#define OnlinePlayerMacro_h

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define STATUS_HEIGHT (iPhoneX ? 44.0f:20.0f)

//一些列版本判断
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#if DEBUG
#define BASE_URL   @"123"
#else
#define BASE_URL   @"456"
#endif

#define WCC_NETWORK_CHECK_OPEN    0  //网络诊断开关（获得ip、DNS等），, Hayden Add at V8.1，Distribution必须为0
#define WCC_MEM_CHECK    0&&(WCC_TEST_VERSION && DEBUG)       // 1: add log at alloc & dealloc，Distribution必须为0
#define WCC_BUGSENSE    0&&(WCC_TEST_VERSION && !DEBUG) //BugSense开关，Distribution必须为0
#define WCC_SECURE_API2    1 //URL加密开关，Distribution请设为1
#define WCC_HCODE    (0 && !TARGET_IPHONE_SIMULATOR) //H码，Distribution请设为0
#define WCC_MATCH    0 //Distribution请设为0
#define WCC_RMB    0 //人民币识别开关，Distribution请设为0
#define WCC_HXCODE   0 //汉信码开关，Distribution请设为1, 现在由于包有问题，临时关掉开关（9.4.5） 等汉信码中心的库没问题后再改，原来开关值为(1 && !TARGET_IPHONE_SIMULATOR)

#define k512M 536870912
#define k256M 268435456


#define RandomColor [UIColor randomColor]

#endif /* OnlinePlayerMacro_h */
