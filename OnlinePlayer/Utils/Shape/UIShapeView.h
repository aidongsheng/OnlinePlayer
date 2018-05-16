//
//  ShapeView.h
//  OnlinePlayer
//
//  Created by wcc on 2018/5/16.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShapeType) {
    ShapeTypeCircle,    //  圆形
    ShapeTypeOval,      //  椭圆
    ShapeTypeTriangle,  //  三角形
    ShapeTypeRectangle, //  四边形
    ShapeTypePolygon,   //  多边形
    ShapeTypeIndicator, //  旋转提示符
};

@interface UIShapeView : UIView
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat strokeStart;
@property (nonatomic, assign) CGFloat strokeEnd;
@property (nonatomic, assign) CGFloat lineDashPhase;
@property (nonatomic, strong) NSArray <NSNumber *> *lineDashPattern;
@property (nonatomic,copy) NSString *fillMode;
@property (nonatomic,copy) NSString *lineJoin;
@property (nonatomic,copy) NSString *fillRule;
@property (nonatomic,copy) NSString *lineCap;

- (instancetype)initWithFrame:(CGRect)frame shapeType:(ShapeType)type;

@end
