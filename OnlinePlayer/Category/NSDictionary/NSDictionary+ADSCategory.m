//
//  NSDictionary+ADSCategory.m
//  tools
//
//  Created by wcc on 2018/3/30.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "NSDictionary+ADSCategory.h"

@implementation NSDictionary (ADSCategory)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未找到键 %@ 对应的值",key);
}
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"can't assign nil to a object");
}
@end
