//
//  FileManager.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

/**
 创建文件夹路径方法
 文件夹路径格式如下:
    /country/province/city/district
    country/province/city/district
    /country/province/city/district/ 等。
 
 @param path 目的路径，可递归创建
 */
+ (void)createPath:(NSString *)path;

/**
 删除文件夹，无法递归删除

 @param path 待删除文件夹
 @return 删除是否成功 YES:成功 NO:失败
 */
+ (BOOL)removePath:(NSString *)path;
//  文稿文件夹
+ (NSString *)documentDirectory;
//  资源文件夹
+ (NSString *)libraryDirectory;
//  图片文件夹
+ (NSString *)picturesDirectory;
//  缓存文件架
+ (NSString *)cachesDirectory;
//  视频文件夹
+ (NSString *)moviesDirectory;
//  下载文件夹
+ (NSString *)downloadsDirectory;
//  回收站
+ (NSString *)trashDirectory;
//  用户文件夹
+ (NSString *)userDirectory;

+ (NSArray *)numberOfFilesAtPath:(NSString *)path;
@end
