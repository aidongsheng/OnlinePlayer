//
//  HomeViewController.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "HomeViewController.h"
#import "OnlineVideoPlayer.h"

typedef void(^ChangeColor)(UIColor *bgColor);

@interface HomeViewController ()<OnlineVideoPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *videoListView;
@end

#define videoURL        @"http://192.168.101.199:8000/download/bilibili.mp4"
#define swoVideoURL     @"http://resbj.swochina.com/video/bb601b829bb22bece99dc037323bbed2.mp4"
static NSString * const identifier = @"video_cell_id";
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.videoListView];
    [[DownloadHelper shareInstance] downloadFileWithURL:swoVideoURL toPath:@"/videos"];
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
