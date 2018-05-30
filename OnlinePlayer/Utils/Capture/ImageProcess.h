//
//  ImageProcess.h
//  wccqr
//
//  Created by dream liu on 12-5-30.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageProcessDelegate;

@interface ImageProcess : NSObject
@property(nonatomic, weak) id<ImageProcessDelegate> delegate;
@property(nonatomic, strong) UIImage *image;

- (id)init;
- (id)initWithImage:(UIImage *) image andDelegate:(id<ImageProcessDelegate>) delegate;
- (void)recognizeBarcode;

@end

@protocol ImageProcessDelegate <NSObject>
@optional
- (void)didRecognizeBarcode:(NSString *) strBarcode withType:(NSInteger) iType inImage:(UIImage *) image;
- (void)failedToRecognizeBarcode;  
@end