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
    _circle = [[UIShapeView alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, self.view.height/3) shapeType:ShapeTypeCircle];
    _circle.backgroundColor = [UIColor colorWithHex:@"33dd88"];
    [self.view addSubview:_circle];
    
    _oval = [[UIShapeView alloc]initWithFrame:CGRectMake(0, self.view.height/3,self.view.width/2, self.view.height/3) shapeType:ShapeTypeOval];
    _oval.backgroundColor = [UIColor colorWithHex:@"339988"];
    [self.view addSubview:_oval];
    
    _rectangle = [[UIShapeView alloc]initWithFrame:CGRectMake(0, self.view.height/3 * 2,self.view.width/2, self.view.height/3) shapeType:ShapeTypeRectangle];
    _rectangle.backgroundColor = [UIColor colorWithHex:@"112288"];
    [self.view addSubview:_rectangle];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view showSuccessMsg:@"操作成功"];
    [_circle wcc_addRotationXAnimation:M_PI * 20 duration:5 autoReverse:NO];
//    [_rectangle wcc_addRotationXYAnimation:M_PI * 4 duration:2 autoReverse:NO];
    [_rectangle wcc_addScaleXYAnimation:0.5 duration:2 autoReverse:NO];
//    [_rectangle wcc_addTranslationXYAnimation:CGPointMake(0, 0) duration:0.5 autoReverse:YES];
}

@end
