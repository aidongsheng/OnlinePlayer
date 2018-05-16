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
        [self showLoadingView];
        [button drawCorner];
    }];
    [button setTitle:@"click me!" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(10, 10, 100, 200);
    [self.view addSubview:button];
    
    UIView *son = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    son.backgroundColor = [UIColor randomColor];
    [self.view addSubview:son];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view showSuccessMsg:@"操作成功"];
    [_circle wcc_addRotationXAnimation:M_PI * 20 duration:5 autoReverse:NO];
    [_rectangle wcc_addRotationXYAnimation:M_PI * 8000 duration:50 autoReverse:YES];
    [_oval wcc_addScaleXYAnimation:M_PI * 2 duration:5 autoReverse:YES];
    [[FPSTool shareInstance] showFPSInfomation];
}

@end
