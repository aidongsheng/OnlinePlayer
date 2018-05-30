//
//  UIImage+Additions.h
//  wochacha
//
//  Created by dream liu on 12-9-7.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Additions)

- (UIImage *)resizableImageWithOffsetTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

- (UIImage *)getScaledImage:(CGFloat) fscale;

- (UIImage *)getSubImage:(CGRect)rect;

- (UIImage*)scaleToSize:(CGSize)size;

-(UIImage*)scaleToSize:(CGSize)size scale:(CGFloat)scale;

- (UIImage*)scaleToSize:(CGSize)size ratio:(CGFloat)ratio;

+ (UIImage *)imageWithUIView:(UIView *)view;

+ (UIImage *)verticalMergeImgA:(UIImage *)imageA andImgB:(UIImage *)imageB;

+ (UIImage *)horizontalMergeImgA:(UIImage *)imageA andImgB:(UIImage *)imageB;

- (UIImage*)imageWithHorizontalTileSize:(CGSize)size; //水平平铺

- (UIImage*)imageWithSize:(CGSize)originSize andCanvasSize:(CGSize)size;

+ (UIImage*)mergeImage:(UIImage*)backgroundImage WithImage:(UIImage *)frontImage andRect:(CGRect)rect;

+ (UIImage*)imageWithSize:(CGSize)size andColor:(UIColor*)color;

+ (NSString *) image2DataBase64URL: (UIImage *) image;
@end
