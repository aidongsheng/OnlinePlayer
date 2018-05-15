//
//  HomeViewController.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "HomeViewController.h"
#import "OnlineVideoPlayer.h"
#import <iflyMSC/iflyMSC.h>

typedef void(^ChangeColor)(UIColor *bgColor);

@interface HomeViewController ()<OnlineVideoPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *videoListView;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end



#define videoURL        @"http://192.168.101.199:8000/download/bilibili.mp4"
#define swoVideoURL     @"http://resbj.swochina.com/video/bb601b829bb22bece99dc037323bbed2.mp4"
static NSString * const identifier = @"video_cell_id";
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.videoListView];
    [[DownloadHelper shareInstance] downloadFileWithURL:swoVideoURL toPath:@"/videos"];
    
    //启动合成会话
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"tangshi300" ofType:@"txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:txtPath]) {
        NSError *error = nil;
        NSStringEncoding encoding;
        NSString *contentOfTxt = [[NSString alloc]initWithContentsOfFile:txtPath usedEncoding:&encoding error:&error];
        NSString *testSizeFilePath = [[FileManager documentDirectory] stringByAppendingPathComponent:@"video/fa4600bd3bda9f2eca398bd8601b49c0.mp4"];
        unsigned long long fileSize = [FileManager getFileSize:testSizeFilePath];
        NSLog(@"文件 %@ 大小为:%llu",testSizeFilePath,fileSize);
        [AudioHelper readText:contentOfTxt byWho:vixk];
        
        if (error) {
            NSLog(@"读取文件错误");
        }else{
            NSLog(@"编码格式 %lu",encoding); //如utf-8编码的会得到4
        }
    }else{
        NSLog(@"文件不存在");
    }
    
    NSLog(@"IP地址:%@",[IPAddressUtil getIPAddress]);
}

- (UITableView *)videoListView
{
    if (_videoListView == nil) {
        _videoListView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _videoListView.delegate = self;
        _videoListView.dataSource = self;
        [_videoListView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _videoListView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FileManager numberOfFilesAtPath:@"/videos"].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = [FileManager numberOfFilesAtPath:@"/videos"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
