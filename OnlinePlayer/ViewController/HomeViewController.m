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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UIButton *clickBtn = [[UIButton alloc]initWithEventBlock:^(UIButton *button) {
        NSLog(@"click");
        [button wcc_addScaleXYAnimation:1.2 duration:0.3 autoReverse:NO];
        [button wcc_addTranslationXYAnimation:CGPointMake(arc4random()%300, arc4random()%500) duration:0.3 autoReverse:NO];
    }];
    clickBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:clickBtn];
    NSString *hexColorString = @"af0fde";
    clickBtn.backgroundColor = [UIColor colorWithHex:hexColorString];
    
    NSLog(@"%li",[@"10ff2011" hexToInt]);
}

+ (void)changeBackgroundColor:(ChangeColor)block
{
    UIColor *color = [UIColor purpleColor];
    block(color);
}
@end
