//
//  FPSTool.h
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPSTool : NSObject
+ (FPSTool *)shareInstance;
- (void)showFPSInfomation;
- (void)hideFPSInfomation;
@end
