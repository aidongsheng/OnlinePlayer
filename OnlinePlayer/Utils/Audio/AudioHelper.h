//
//  AudioHelper.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/14.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ReaderName) {
    xiaoyan,
    xiaoyu,
    catherine,
    henry,
    vimary,
    vixy,
    vixq,
    vixf,
    vixl,
    vixr,
    vixyun,
    vixk,
    vixqa,
    vixyin,
    vixx,
    vinn,
    vils,
};

@interface AudioHelper : NSObject

+ (void)readText:(NSString *)text byWho:(ReaderName)readerName;

@end
