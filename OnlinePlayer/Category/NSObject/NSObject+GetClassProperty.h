//
//  NSObject+GetClassProperty.h
//  tools
//
//  Created by wcc on 2018/4/10.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GetClassProperty)

/**
 打印 Class 属性名称以及类型
 */
+ (void)printClassProperties:(Class)cls;
@end
