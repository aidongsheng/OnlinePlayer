//
//  WCCBarCaptureReader.m
//  wccBarScan
//
//  Created by dream liu on 12-11-20.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import <libkern/OSAtomic.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <sys/utsname.h>
#import "WCCCaptureReader.h"

@interface WCCCaptureReader ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t queue;
}
@property(nonatomic, assign) BOOL enableReader;

@end

@implementation WCCCaptureReader
@synthesize captureOutput = _captureOutput;
@synthesize delegate = _delegate;
@synthesize orientation = _orientation;
@synthesize fScale = _fScale;
@synthesize isAutoFocusSupport = _isAutoFocusSupport;

#pragma mark - getter & setter
- (BOOL)enableReader
{
    return (OSAtomicOr32Barrier(0, &state)&RUNNING);
}

- (void)setEnableReader:(BOOL)enableReader
{
    if (!enableReader) {
        OSAtomicOr32Barrier(STOPPED, &state);
    }else if (!(OSAtomicOr32Barrier(RUNNING, &state)&RUNNING)){
        OSAtomicOr32Barrier(~PAUSED, &state);
    }
}

#pragma mark - inside methods
- (UIImage *)creatImage:(unsigned char *)data width:(int)iw height:(int)ih
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        return nil;
    }
    int iwidth = iw*0.6;
    int iheight = ih;
    unsigned char *imgData = malloc(iwidth*iheight*4);
    unsigned char *srcData = data + (int)(iw*0.2*4);
    for (int i=0; i<ih; i++) { 
        unsigned char *psrc = srcData + i*iw*4;
        unsigned char *pdst = imgData + i*iwidth*4;
        memcpy(pdst, psrc, iwidth*4);
    }

    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgData, (iwidth*iheight*4), NULL);
    CGImageRef cgImage = CGImageCreate(iwidth,iheight, 8, 32, iwidth*4, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationRight];
    
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CGImageRelease(cgImage);
    
    // 直接释放imgData会导致创建好的image丢失数据，因此先转换为NSData再实例化
    NSData *dataImg = UIImageJPEGRepresentation(image, 1);
    image = [[UIImage alloc]initWithData:dataImg];
    free(imgData);
    
    return image;
}

/*
- (UIImage *)creatImageFromRawRGB:(unsigned char *)data width:(int)iw height:(int)ih
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        return nil;
    }
    int iwidth = iw;
    int iheight = ih;
    unsigned char *imgData = malloc(iwidth*iheight*4);
    unsigned char *srcData = data ;
    for (int i=0; i<(ih*iw); i++) {
        unsigned char *psrc = srcData + i*3;
        unsigned char *pdst = imgData + i*4;
        memcpy(pdst, psrc, 3);
        pdst[3] = 255 ;
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgData, (iwidth*iheight*4), NULL);
    CGImageRef cgImage = CGImageCreate(iwidth,iheight, 8, 32, iwidth*4, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationRight];
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CGImageRelease(cgImage);
    return image;
}
*/
- (UIImage *)creatImageFromRawRGB:(unsigned char *)pImgRGB width:(int)iw height:(int)ih    
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        return nil;
    }
//    int iBytesPerPixelRGB = 3 ;     // Source
    int iBytesPerPixelRGBA = 4 ;    // Destination
    int iwidth = iw;
    int iheight = ih;
    int iLength = iw * ih ;
    unsigned char *pImgRGBA = malloc(iLength*iBytesPerPixelRGBA);
    if ( pImgRGBA == nil ) return nil ;
    
    for (int i=0; i<(ih*iw); i++) {
        unsigned char *psrc = pImgRGB + i*3;
        unsigned char *pdst = pImgRGBA + i*4;
        memcpy(pdst, psrc, 3);
        pdst[3] = 255 ;
    }
    
    // wrong codes !
//    memset ( pImgRGBA, 1, iLength*iBytesPerPixelRGBA ) ;
//    for (int i=0; i<iLength; i++) {
//        memcpy(pImgRGBA, pImgRGB, iBytesPerPixelRGB*sizeof(unsigned char));
//        pImgRGBA[3] = 255 ; 
//        pImgRGB  += iBytesPerPixelRGB ;
//        pImgRGBA += iBytesPerPixelRGBA;
//    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, pImgRGBA, (iLength*iBytesPerPixelRGBA), NULL);
    CGImageRef cgImage = CGImageCreate(iwidth,iheight, 8, 32, iwidth*iBytesPerPixelRGBA, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CGImageRelease(cgImage);
    return image;
}

#pragma mark - life cycle
- (id)init
{
    self = [super init];
    if (self) {
        //create AVCaptureVideoDataOutput
        self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        //config the AVCaptureVideoDataOutput
        self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
        self.captureOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
        //create GCD queue
        queue = dispatch_queue_create("BarCaptureReader", NULL);
        [self.captureOutput setSampleBufferDelegate:self queue:queue];
        self.fScale = 1.0f;
        channel = 0;
        m_iTakeSnapAndStop = 0  ;
    }
    return self;
}

- (void)dealloc
{
    [self.captureOutput setSampleBufferDelegate:nil queue:queue];
}

#pragma mark - public methods
- (void)willStartRunning
{
    self.enableReader = YES;
    if ([MainModel sharedObject].bNewThaniPhone4) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[self.captureOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        });
    }
}

- (void)willStopRunning
{
    self.enableReader = NO;
    if ([MainModel sharedObject].bNewThaniPhone4) {
        [[self.captureOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    }
}

- (void)recognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    //should override by subclass 
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    uint32_t _state = OSAtomicOr32Barrier(0, &state);
    if ((_state & (PAUSED | RUNNING)) != RUNNING) {
        return;
    }
    @autoreleasepool {
        [self recognizeWithSampleBuffer:sampleBuffer];
    }
}

- (void) takeSnapAndStop
{
    m_iTakeSnapAndStop = 1 ;
}

@end
