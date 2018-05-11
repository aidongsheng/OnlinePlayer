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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    [[DownloadHelper shareInstance] downloadFileWithURL:swoVideoURL toPath:@"china/anui/suzh阿斯蒂芬ou"];
//    [HomeViewController changeBackgroundColor:^(UIColor *bgColor) {
//        self.view.backgroundColor = bgColor;
//    }];
//
    UIButton *clickBtn = [[UIButton alloc]initWithEventBlock:^(UIButton *button) {
        NSLog(@"click");
    }];
    clickBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:clickBtn];
    NSString *hexColorString = @"af0fd";
    clickBtn.backgroundColor = [UIColor colorWithHex:hexColorString];
    NSLog(@"%@ 是有效的十六进制数 ? %i",hexColorString,[hexColorString isValidHex]);
}

+ (void)changeBackgroundColor:(ChangeColor)block
{
    UIColor *color = [UIColor purpleColor];
    block(color);
}
@end
