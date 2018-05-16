//
//  ShapeView.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/16.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "UIShapeView.h"

@interface UIShapeView()
@property (nonatomic, assign) NSInteger start, end;
@end

static UIShapeView * instance = nil;

@implementation UIShapeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame shapeType:(ShapeType)type
{
    if (self = [super initWithFrame:frame]) {
        [self configureDefaultParameter];
        self.frame = frame;
        [self initWithShapeType:type];
    }
    return self;
}

/**
 配置默认参数
 */
- (void)configureDefaultParameter {
    self.strokeColor = [UIColor clearColor];
    self.borderColor = [UIColor clearColor];
    self.fillColor = [UIColor orangeColor];
    self.lineWidth = 0;
    self.lineCap = kCALineJoinRound;
    self.lineCap = kCALineCapRound;
    self.strokeStart = 0;
    self.strokeEnd = 1;
}

- (void)initWithShapeType:(ShapeType)type
{
    if (type == ShapeTypeCircle) {
        [self initWithCircleType];
    }else if (type == ShapeTypeOval) {
        [self initWithOvalType];
    }else if (type == ShapeTypeTriangle) {
        [self initWithTriangleType];
    }else if (type == ShapeTypeRectangle) {
        [self initWithRectangleType];
    }else if (type == ShapeTypePolygon) {
        
    }else if (type == ShapeTypeIndicator) {
        [self initWithIndicatorType];
    }
}

- (void)initWithCircleType
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    
    CGFloat radius = self.width > self.height ? self.height/2 : self.width/2;
    NSLog(@"高:%.1f,宽:%.1f,半径:%.1f,中心点:{%.1f,%.1f}",self.height,self.width,radius,self.center.x,self.center.y);
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    shapeLayer.fillMode = kCAFillModeBoth;
    shapeLayer.path = circle.CGPath;
}

- (void)initWithOvalType
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.borderColor = [UIColor greenColor].CGColor;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;

    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.78;
    shapeLayer.fillMode = kCAFillModeBoth;
    shapeLayer.path = circle.CGPath;
}

- (void)initWithTriangleType
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    shapeLayer.borderColor = [UIColor redColor].CGColor;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    [triangle addLineToPoint:CGPointMake(self.width/2, 0)];
    [triangle addLineToPoint:CGPointMake(self.width/2 + tan(M_PI/6) * self.height, self.height)];
    [triangle addLineToPoint:CGPointMake(self.width/2 - tan(M_PI/6) * self.height, self.height)];
    
    [triangle stroke];
    shapeLayer.path = triangle.CGPath;
}
- (void)initWithRectangleType
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:self.bounds];
    shapeLayer.path = rectangle.CGPath;
}

- (void)initWithIndicatorType
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    CGFloat radius = self.width > self.height ? self.height/2 : self.width/2;
    NSLog(@"高:%.1f,宽:%.1f,半径:%.1f,中心点:{%.1f,%.1f}",self.height,self.width,radius,self.center.x,self.center.y);
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    shapeLayer.fillMode = kCAFillModeBoth;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    shapeLayer.lineWidth = 30;
    shapeLayer.path = circle.CGPath;
    __block __weak typeof(self) weakSelf = self;
    
    [NSTimer scheduledTimerWithTimeInterval:0.001 block:^(NSTimer * _Nonnull timer) {
        weakSelf.start = weakSelf.start + 1;
        weakSelf.end = weakSelf.end + 2;
        CGFloat begin = (weakSelf.start % 100) / 100.0;
        CGFloat finish = (weakSelf.end % 100) / 100.0;
        shapeLayer.strokeStart = begin;
        shapeLayer.strokeEnd = finish;
        NSLog(@"开始:%.1f 结束:%.1f",begin,finish);
    } repeats:YES];
}


- (void)setFillColor:(UIColor *)fillColor
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.fillColor = fillColor.CGColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.strokeColor = strokeColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.borderColor = borderColor.CGColor;
}

- (void)setPath:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.path = path.CGPath;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.lineWidth = lineWidth;
}

- (void)setFillMode:(NSString *)fillMode
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.fillMode = fillMode;
}

- (void)setLineDashPhase:(CGFloat)lineDashPhase
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.lineDashPhase = lineDashPhase;
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    shapeLayer.lineDashPattern = lineDashPattern;
}

- (void)setLineJoin:(NSString *)lineJoin
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    [shapeLayer setLineJoin:lineJoin];
}
- (void)setFillRule:(NSString *)fillRule
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    [shapeLayer setFillRule:fillRule];
}
- (void)setLineCap:(NSString *)lineCap
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self layer];
    [shapeLayer setLineCap:lineCap];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

@end
