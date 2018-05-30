//
//  MainModel.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/24.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "MainModel.h"
#import <sys/utsname.h>

static MainModel *instance = nil;

@implementation MainModel
+ (MainModel *)sharedObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MainModel alloc]init];
    });
    return instance;
}
- (NSUInteger)physicalMemory
{
    return [NSProcessInfo processInfo].physicalMemory;
}

- (BOOL)bNewThaniPhone4
{
    struct utsname u;
    uname(&u);
    
    NSString *strMachine = [NSString stringWithFormat:@"%s",u.machine];
    strMachine = [strMachine substringWithRange:NSMakeRange(6, 1)];
    NSInteger ver = [strMachine integerValue];
    return ver >= 4 ? YES : NO;
}
@end
