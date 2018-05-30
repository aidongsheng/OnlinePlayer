//
//  DownloadHelper.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "DownloadHelper.h"

@interface DownloadHelper()<NSURLSessionDataDelegate,NSURLConnectionDataDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) float downloadProgress;
@property (nonatomic, copy)   downloadProgress block;
@end

@implementation DownloadHelper
+ (DownloadHelper *)shareInstance
{
    static DownloadHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[DownloadHelper alloc]init];
        }
    });
    return instance;
}
- (instancetype)init{
    if (self = [super init]) {
        [NetworkStatusHelper startMonitorNetworkStatus:^(AFNetworkReachabilityStatus status) {
            
        }];
    }
    return self;
}

/**
 下载文件
 */
- (void)downloadFileWithURL:(NSString *)videlUrl toPath:(NSString *)path
{
    [FileManager createPath:path];
    _path = path;
    NSURL *urlVideoUrl = [NSURL URLWithString:videlUrl];
    NSMutableURLRequest *reqDownload = [NSMutableURLRequest requestWithURL:urlVideoUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadtask = [session downloadTaskWithRequest:reqDownload];
    [downloadtask resume];
    _isDownloading = YES;
}
//  上行数据进度信息再次获取
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    float eachFileLength = bytesSent;
    float per = totalBytesSent/(float)totalBytesExpectedToSend;
    NSLog(@"上传进度:%3.1f%%   上传速度:%5.1f",per,(float)eachFileLength/1024/1024);
}
//  下载完成在此处实现，可进行保存操作
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成 location:%@",location);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *moveFileError = nil;
    NSString *fileName = downloadTask.response.suggestedFilename;
    
    _path = [[FileManager documentDirectory] stringByAppendingPathComponent:_path];
    _path = [_path stringByAppendingPathComponent:fileName];
    
    [fileMgr moveItemAtPath:location.path toPath:_path error:&moveFileError];
    if (moveFileError) {
        NSLog(@"下载完成，移动文件至目的文件夹 %@ 失败",_path);
    }else{
        NSLog(@"下载完成，移动文件至目的文件夹 %@ 成功",_path);
    }
    _isDownloading = NO;
}
//  断点下载在此处实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"断点下载在此处实现");
}
//  下行进度信息在此处实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float packageLength = bytesWritten;
    float per = totalBytesWritten/(float)totalBytesExpectedToWrite;
    _downloadProgress = per;
    
    NSLog(@"下行进度:%3.1f%%   下行网速:%5.1f kbps",per * 100,(float)packageLength/1024);
    NSDictionary *asd;
    [asd modelDescription];
    _isDownloading = YES;
}



@end
