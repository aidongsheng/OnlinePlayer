//
//  HomeViewController.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "HomeViewController.h"
#import "OnlineVideoPlayer.h"

@interface HomeViewController ()<OnlineVideoPlayerDelegate>

@end

#define videoURL        @"http://192.168.101.199:8000/download/bilibili.mp4"
#define swoVideoURL     @"http://resbj.swochina.com/video/bb601b829bb22bece99dc037323bbed2.mp4"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    OnlineVideoPlayer *playerView =[[ OnlineVideoPlayer alloc]initWithVideoUrl:swoVideoURL delegate:self];
//    playerView.frame = [UIScreen mainScreen].bounds;
//    [self.view addSubview:playerView];
//    [playerView wcc_addRotationXYAnimation:M_PI_2 duration:1 autoReverse:NO];
//    [playerView wcc_addScaleXYAnimation:2 duration:1 autoReverse:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[DownloadHelper shareInstance] downloadFileWithURL:swoVideoURL toPath:@"china/anhui/suzhou"];
}
@end
