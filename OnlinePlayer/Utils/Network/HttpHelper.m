//
//  HttpHelper.m
//  OnlinePlayer
//
//  Created by josan on 2018/5/15.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper

- (NSString *)baseUrl
{
    return BASE_URL;
}
- (BOOL)useCDN
{
    return NO;
}
- (BOOL)allowsCellularAccess
{
    return YES;
}

@end
