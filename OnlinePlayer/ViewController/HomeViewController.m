//
//  HomeViewController.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/10.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "HomeViewController.h"
#import "UIShapeView.h"

@interface HomeViewController ()
@property (nonatomic, strong) UIShapeView *circle, *oval, *rectangle;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [[UIButton alloc]initWithEventBlock:^(UIButton *button) {
        NSLog(@"是否是越狱手机：%@",[UIDevice currentDevice].isJailbroken ? @"是" : @"否");
    }];
    [button setTitle:@"click me!" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(10, 10, 100, 200);
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    NSString *strDownloadUrl = @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAp0lEQVQoU3WPUQ3CQBBEZxQADkABOOCmBggKQEKlIAEcVEG3OKgDcAAoWHKXu6Zp2knuY2fezuaIiczsHi1J13HE8WBmWwCv7O0kvUs+BRsApxw2ks4DmE8dAcS2OcXWjhm8LEDFfqTTbdv2JPdzsLs/q6oKCTSzNYDPQutG0nf4jJn5HCgpMaUxxOJouPsvBeQqL0pSV8CDu3ckbwDii6rdvSYZJPV/KRI9xFS/jDcAAAAASUVORK5CYII=";
//    [[DownloadHelper shareInstance]downloadFileWithURL:strDownloadUrl
//                                                toPath:@"/jiushi/ak"];
    
    
}

@end
