//
//  DownloadHelper.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject

+ (DownloadHelper *)shareInstance;

- (void)downloadFileWithURL:(NSString *)videlUrl toPath:(NSString *)path;
@end
