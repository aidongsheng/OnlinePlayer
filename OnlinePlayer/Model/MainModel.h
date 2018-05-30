//
//  MainModel.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/24.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MainModel : NSObject
+ (MainModel *)sharedObject;
@property (nonatomic, assign, readonly) NSUInteger physicalMemory;
@property (nonatomic, assign ,readonly) BOOL bNewThaniPhone4;
@property (nonatomic, strong) NSString *strRainbowDebugInfo;//用于保存彩虹码扫描时的Debug信息
@property (nonatomic, assign) BOOL bDecodingRainbowImage;

@end
