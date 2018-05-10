//
//  NSObject+GetClassProperty.m
//  tools
//
//  Created by wcc on 2018/4/10.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "NSObject+GetClassProperty.h"

@implementation NSObject (GetClassProperty)

+ (void)printClassProperties:(Class)cls
{
    unsigned int count;
    objc_property_t * prop_list = class_copyPropertyList([cls class], &count);
    for(int index = 0;index<count;index++) {
        objc_property_t property = prop_list[index];
        NSLog(@"【属性名称:%40s】 【属性类型:%40s】",property_getName(property),property_getAttributes(property));
    }
}

@end
