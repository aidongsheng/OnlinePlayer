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

@end
