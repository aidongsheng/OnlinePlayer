//
//  NSString+ADS.h
//  tools
//
//  Created by wcc on 2018/4/27.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ADS)

- (NSString *)ads_MD5String;

- (NSString *)ads_MD4String;

- (NSString *)ads_SHA1String;

- (NSString *)ads_SHA256String;

- (NSString *)ads_SHA384String;

- (NSString *)ads_SHA512String;

- (NSString *)ads_CRC32String;


/**
 移除字符串中包含的所有字符

 @param charsToBeRemoved 待移除字符
 @return 移除字符后的字符串
 */
- (NSString *)removeAllCharContainedInString:(NSString *)charsToBeRemoved;

/**
 字符串查找替换

 @param findedString 查找到的字符串
 @param replacedString 替换字符串
 @return 替换过后的字符串
 */
- (NSString *)replaceString:(NSString *)findedString withString:(NSString *)replacedString;

- (int *)hexToDecimal;

- (NSInteger)hexToInt;

- (BOOL)isValidHex;
@end
