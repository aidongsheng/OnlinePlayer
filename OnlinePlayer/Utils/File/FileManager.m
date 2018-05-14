//
//  FileManager.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (void)createPath:(NSString *)path
{
    NSArray *folders = [path componentsSeparatedByString:@"/"];
    NSMutableArray *muFolders = [folders mutableCopy];
    for (NSString *folder in folders) {
        if (folder.length == 0) {
            [muFolders removeObject:folder];
        }
    }
    NSString *documentPath = [FileManager documentDirectory];
    for (int index = 0; index < muFolders.count; index++) {
        documentPath = [documentPath stringByAppendingPathComponent:muFolders[index]];
    }
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDirectory]) {
        NSError *createFolerErr = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&createFolerErr];
        if (createFolerErr) {
            NSLog(@"创建文件路径 %@ 失败",documentPath);
        }else{
            NSLog(@"创建文件路径 %@ 成功",documentPath);
        }
    }
}

+ (BOOL)removePath:(NSString *)path
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    path = [[FileManager documentDirectory] stringByAppendingPathComponent:path];
    NSError *removePathError = nil;
    return [fileMgr removeItemAtPath:path error:&removePathError];
}

+ (NSString *)documentDirectory
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return documentPath;
}


+ (NSString *)libraryDirectory
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return libraryPath;
}

+ (NSString *)picturesDirectory
{
    NSString *picturesPath = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) lastObject];
    return picturesPath;
}



+ (NSString *)cachesDirectory
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return cachesPath;
}


+ (NSString *)moviesDirectory
{
    NSString *moviesPath = [NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES) lastObject];
    return moviesPath;
}

+ (NSString *)downloadsDirectory
{
    NSString *downloadsPath = [NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) lastObject];
    return downloadsPath;
}


+ (NSString *)trashDirectory
{
    if (@available(iOS 11.0, *)) {
        NSString *trashPath = [NSSearchPathForDirectoriesInDomains(NSTrashDirectory, NSUserDomainMask, YES) lastObject];
        return trashPath;
    } else {
        NSLog(@"版本 11.0 之前无法使用回收站功能");
        return @"";
    }
}


+ (NSString *)userDirectory
{
    NSString *userPath = [NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES) lastObject];
    return userPath;
}

+ (NSArray *)numberOfFilesAtPath:(NSString *)path
{
    path = [[FileManager documentDirectory] stringByAppendingPathComponent:path];
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    NSLog(@"files = %@",files);
    if (error) {
        NSLog(@"枚举文件夹 %@ 失败",path);
        return nil;
    }else{
        NSLog(@"枚举文件夹 %@ 成功",path);
        return files;
    }
}

+ (BOOL)isFileExsitAtPath:(NSString *)filePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    filePath = [filePath ads_SHA256String];
    return [fileMgr fileExistsAtPath:filePath];
}

+ (unsigned long long )getFileSize:(NSString *)filePath
{
    NSError *error = nil;
    //获取newFile2的大小
    NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if(error == nil){
        unsigned long long size = [[fileAttr objectForKey:NSFileSize] unsignedLongLongValue];
        return size;
    }else{
        return -1;
    }
}



@end
