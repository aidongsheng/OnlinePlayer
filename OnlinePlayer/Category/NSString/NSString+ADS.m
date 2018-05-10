//
//  NSString+ADS.m
//  tools
//
//  Created by wcc on 2018/4/27.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "NSString+ADS.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>

@implementation NSString (ADS)
- (NSString *)ads_MD5String
{
    const char *origin_chr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(origin_chr, (CC_LONG)strlen(origin_chr), result);
    NSMutableString *hash = [NSMutableString new];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x",result[i]];
    return [hash lowercaseString];
}
- (NSString *)ads_MD4String
{
    const char *origin_chr = [self UTF8String];
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(origin_chr, (CC_LONG)strlen(origin_chr), result);
    NSMutableString *hash = [NSMutableString new];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x",result[i]];
    return [hash lowercaseString];
}
- (NSString *)ads_SHA1String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}

- (NSString *)ads_SHA256String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x",digest[i]];
    }
    return hash;
}
- (NSString *)ads_SHA384String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x",digest[i]];
    }
    return hash;
}

- (NSString *)ads_SHA512String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x",digest[i]];
    }
    return hash;
}

- (NSString *)ads_CRC32String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uLong result = crc32(0, data.bytes, (uint)data.length);
    return [NSString stringWithFormat:@"%08x",(uint32_t)result];
}


@end
