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

- (NSString *)removeAllCharContainedInString:(NSString *)charsToBeRemoved
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:charsToBeRemoved];
    NSArray *arrSet = [self componentsSeparatedByCharactersInSet:charSet];
    NSString *strDest = [arrSet componentsJoinedByString:@""];
    return strDest;
}
- (NSString *)replaceString:(NSString *)findedString withString:(NSString *)replacedString
{
    return [self stringByReplacingOccurrencesOfString:findedString withString:replacedString];
}

- (int *)hexToDecimal
{
    if ([self isValidHex])
    {
        NSString *hexStr;
        if ([self hasPrefix:@"0x"]) {
            hexStr = [self replaceString:@"0x" withString:@""];
        }else{
            hexStr = [NSString stringWithFormat:@"%@",self];
        }
        
        int *int_ch = malloc(sizeof(int) * (hexStr.length/2));
        
        for (int i = 0; i < hexStr.length; i += 2) {
            NSString *hex = [hexStr substringWithRange:NSMakeRange(i, 2)];
            unichar hex_char1 = [hex characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
            int int_ch1;
            if(hex_char1 >= '0'&& hex_char1 <='9')
                int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
            else if(hex_char1 >= 'A'&& hex_char1 <='F')
                int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
            else
                int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
            
            
            unichar hex_char2 = [hex characterAtIndex:1]; ///两位16进制数中的第二位(低位)
            int int_ch2;
            if(hex_char2 >= '0'&& hex_char2 <='9')
                int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
            else if(hex_char1 >= 'A'&& hex_char1 <='F')
                int_ch2 = hex_char2-55; //// A 的Ascll - 65
            else
                int_ch2 = hex_char2-87; //// a 的Ascll - 97
            
            int_ch[i/2] = int_ch1+int_ch2;
        }
        return int_ch;
    }
    else
    {
        NSLog(@"无效十六进制字符串");
        return NULL;
    }
}

- (NSInteger)hexToInt
{
    if ([self isValidHex]) {
        NSString *hex;
        if ([self hasPrefix:@"0x"]) {
            hex = [self substringFromIndex:2];
        }else{
            hex = [NSString stringWithFormat:@"%@",self];
        }
        int *ptr = [hex hexToDecimal];
        NSInteger count = hex.length/2;
        NSInteger total = 0;
        NSInteger value = 0;
        for (int index = 0; index < count; ++index) {
            int tmp = ptr[index];
            NSUInteger offset = (count - index - 1);
            value = (tmp << (offset * 8));
            total += value;
            NSLog(@"第 %ld 位十六进制数 %d, 向高位偏移 %li 位,得到结果 : %li, 运算总和 : %ld",offset,tmp,(count - index - 1)*8,(long)value,total);
        }
        return total;
    }
    return 0;
}

- (BOOL)isValidHex
{
    NSUInteger count = [self length];
    int mod = count%2;
    if (mod == 1) {
        return false;
    }
    NSString *str;
    if ([self hasPrefix:@"0x"]) {
        str = [self replaceString:@"0x" withString:@""];
    }else {
        str = [NSString stringWithFormat:@"%@",self];
    }
    
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        NSLog(@"%d",ch);
        if (!(ch >= 'A' && ch <= 'Z') && !(ch >= 'a' && ch <= 'z') && !(ch >= '0' && ch <= '9')) {  //  若 ch 符合 [A-Za-z0-9]
            return false;
        }
    }
    return true;
}

@end
