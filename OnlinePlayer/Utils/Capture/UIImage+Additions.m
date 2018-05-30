//
//  UIImage+Additions.m
//  wochacha
//
//  Created by dream liu on 12-9-7.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)resizableImageWithOffsetTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    }else{
        return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
}

- (UIImage *)getScaledImage:(CGFloat) fscale{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*fscale, self.size.height*fscale));
    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width*fscale, self.size.height*fscale)];
    UIImage *imgScale = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgScale;
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

-(UIImage*)scaleToSize:(CGSize)size
{
//    UIGraphicsBeginImageContext(size);
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
    //上面注释的方法是失真压缩，下面的方法是非失真压缩
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage*)scaleToSize:(CGSize)size scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
    
- (UIImage*)scaleToSize:(CGSize)size ratio:(CGFloat)ratio
{
    UIImage *scaledImage = [self scaleToSize:size];
    NSData *data=UIImageJPEGRepresentation(scaledImage, ratio);
    scaledImage = [UIImage imageWithData:data];
    return scaledImage;
}

+ (UIImage *)imageWithUIView:(UIView *)view
{
    CGSize screenShotSize = view.bounds.size;
    UIImage *img;
    UIGraphicsBeginImageContext(screenShotSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view drawLayer:view.layer inContext:ctx];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)verticalMergeImgA:(UIImage *)imageA andImgB:(UIImage *)imageB
{
    CGSize size;
    size.width = MAX(imageA.size.width, imageB.size.width);
    size.height = imageA.size.height + imageB.size.height + 2.0f;
    UIGraphicsBeginImageContext(size);
    
    [imageA drawInRect:CGRectMake(0, 0, imageA.size.width, imageA.size.height)];
    
    [imageB drawInRect:CGRectMake(0, imageA.size.height + 2.0f, imageB.size.width, imageB.size.height)];
    
    UIImage* mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mergeImage;
}

+ (UIImage *)horizontalMergeImgA:(UIImage *)imageA andImgB:(UIImage *)imageB
{
    CGSize size;
    size.height = MAX(imageA.size.height, imageB.size.height);
    size.width = imageA.size.width + imageB.size.width;
    UIGraphicsBeginImageContext(size);
    
    [imageA drawInRect:CGRectMake(0, 0, imageA.size.width, imageA.size.height)];
    
    [imageB drawInRect:CGRectMake(imageA.size.width, 0.0f, imageB.size.width, imageB.size.height)];
    
    UIImage* mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mergeImage;
}

- (UIImage*)imageWithHorizontalTileSize:(CGSize)size //水平平铺
{
    CGFloat fHeight = self.size.height;
    fHeight = fHeight > size.height ? size.height : fHeight;
    CGFloat fWidth = self.size.width;
    fWidth = fWidth > size.width ? size.width : fWidth;
    CGFloat fOriginX = 0;
    UIGraphicsBeginImageContext(size);
    while (fOriginX < size.width) {
        [self drawInRect:CGRectMake(fOriginX, 0, fWidth, fHeight)];
        fOriginX += fWidth;
        fWidth = size.width - fOriginX < fWidth ? size.width - fOriginX : fWidth;
    }
    UIImage* mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

- (UIImage*)imageWithSize:(CGSize)originSize andCanvasSize:(CGSize)size
{
//    if (size.width || size.height) {
//        return nil;
//    }
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *bgColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGRect bgRect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddRect(context, bgRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [self drawInRect:CGRectMake((size.width-originSize.width)/2, (size.height-originSize.height)/2, originSize.width, originSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage*)mergeImage:(UIImage*)backgroundImage WithImage:(UIImage *)frontImage andRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [frontImage drawInRect:rect];
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//得到一张纯色图片
+ (UIImage*)imageWithSize:(CGSize)size andColor:(UIColor*)color
{
    UIImage *pressedColorImg;
    if (size.height>0 && size.width>0) {
        if (!color) {
            color = [UIColor whiteColor];
        }
        UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
        [color set];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return pressedColorImg;
}

+ (NSString *) image2DataBase64URL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
@end
