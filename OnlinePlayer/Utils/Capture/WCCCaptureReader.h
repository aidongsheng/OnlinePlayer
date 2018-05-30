//
//  WCCBarCaptureReader.h
//  wccBarScan
//
//  Created by dream liu on 12-11-20.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCCCaptureReaderDelegate.h"

enum {
    STOPPED = 0,
    RUNNING = 1,
    PAUSED = 2,
};

@class AVCaptureVideoDataOutput;
@interface WCCCaptureReader : NSObject
{
    volatile uint32_t state;
    volatile int32_t channel;
    volatile int8_t  m_iTakeSnapAndStop;  // 0: not snap , 1 : shoot snap and stop 
}
// 是否启动彩虹码识别 Hayden Add @ 2015.08.20 v8.3
@property (nonatomic, assign) BOOL bRainbowEnable;

@property (nonatomic, assign) NSInteger iScanType;

@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;
@property (nonatomic, weak) id<WCCCaptureReaderDelegate> delegate;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) CGFloat fScale;
@property (nonatomic, assign) BOOL isAutoFocusSupport;

- (void)willStartRunning;
- (void)willStopRunning;
- (void)recognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (UIImage*) creatImage:(unsigned char*)data width:(int)iw height:(int)ih;
- (UIImage*) creatImageFromRawRGB:(unsigned char *)data width:(int)iw height:(int)ih;
- (void) takeSnapAndStop ;

@end
