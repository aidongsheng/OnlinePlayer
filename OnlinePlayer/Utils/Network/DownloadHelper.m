//
//  DownloadHelper.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "DownloadHelper.h"

@interface DownloadHelper()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>

@end

@implementation DownloadHelper
/**
 下载视频
 */
+ (void)downloadFileWithURL:(NSString *)videlUrl
{
    NSURL *urlVideoUrl = [NSURL URLWithString:videlUrl];
    NSMutableURLRequest *reqDownload = [NSMutableURLRequest requestWithURL:urlVideoUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadtask = [session downloadTaskWithRequest:reqDownload];
    [downloadtask resume];
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
    NSLog(@"location:%@",location);
}
//  断点下载在此处实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
//  下行进度信息在此处实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float packageLength = bytesWritten;
    float per = totalBytesWritten/(float)totalBytesExpectedToWrite;
    NSLog(@"下行进度:%3.1f%%   上行速度:%5.1f kb",per,(float)packageLength/1024);
}
//  收到接口 response 代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
}
//  收到下载数据代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"收到下载数据代理方法");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
API_AVAILABLE(ios(9.0)){
    
}

@end
