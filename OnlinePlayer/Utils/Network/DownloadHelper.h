//
//  DownloadHelper.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^downloadProgress)(float progress);

@interface DownloadHelper : NSObject
@property (nonatomic,readonly) BOOL isDownloading;  //  正在下载标识符
+ (DownloadHelper *)shareInstance;

- (void)downloadFileWithURL:(NSString *)videlUrl toPath:(NSString *)path;


@end
