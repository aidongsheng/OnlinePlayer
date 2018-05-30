//
//  WCCCaptureCartReader.m
//  wochacha
//
//  Created by dream liu on 13-5-8.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <libkern/OSAtomic.h>
#import "WCCCaptureCartReader.h"

typedef struct HZRECT
{
    int x;
    int y;
    int width;
    int height;
}HZRECT;

 hz_ProcessFrame(unsigned char *m_FrameData,int width, int height, HZRECT *m_ActiveRect,char *m_result,int *m_bartype,int rotate_flag, int enable_blur);

@interface WCCCaptureCartReader ()

@property(nonatomic, strong) NSString *strBarcode;
@property(nonatomic, assign) NSInteger iBarType;

@end

@implementation WCCCaptureCartReader
@synthesize
strBarcode = _strBarcode,
iBarType = _iBarType;

- (id)init
{
    self = [super init];
    if (self) {
        //set captureOutput property
        self.captureOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    }
    return self;
}

- (void)recognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef buf = CMSampleBufferGetImageBuffer(sampleBuffer);
    if(CMSampleBufferGetNumSamples(sampleBuffer) != 1 ||
       !CMSampleBufferIsValid(sampleBuffer) ||
       !CMSampleBufferDataIsReady(sampleBuffer) ||
       !buf) {
        return;
    }
    CVReturn rc =CVPixelBufferLockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
    if(rc) {
        return;
    }
    size_t iFrameWidth = CVPixelBufferGetWidth(buf);
    size_t iFrameHeight = CVPixelBufferGetHeight(buf);
    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(buf);
    uint8_t *data = malloc(iFrameWidth*iFrameHeight*sizeof(uint8_t));
    OSAtomicAdd32(1, &channel);
    int iChannel =channel & 0x0003;
    //iChanel 0-Blue 1-Green 2-Red 3-Gray
    if (iChannel == 3) {
        for (int i=0; i<iFrameWidth*iFrameHeight; i++)//pixel format is BGRA
            data[i] = baseAddress[i*4]*0.072169 + baseAddress[i*4+1]*0.71516 + baseAddress[i*4+2]*0.212671;
    }else{
        for (int i=0; i<iFrameWidth*iFrameHeight; i++)
            data[i] = baseAddress[i*4+iChannel];
    }
    int w = iFrameWidth ;
    int h = iFrameHeight ;
    if(data) {
        HZRECT rect;
        char m_result[5000];
        int result = 0;
        if (self.orientation == UIInterfaceOrientationLandscapeLeft || self.orientation == UIInterfaceOrientationLandscapeRight) {
            float ratio = (self.fScale -1.0f)/2.0f;
            float scaleWidth = w/self.fScale;
            float scaleHeight = h/self.fScale;
            rect.x = 0;
            rect.y = 0;
            rect.width = scaleWidth;
            rect.height = scaleHeight/3.0f+1;
            int xoffset = scaleWidth*ratio;
            int yoffset = scaleHeight*ratio;
            unsigned char *rectData = (unsigned  char*)malloc(rect.width*rect.height*sizeof(unsigned char));
            for (int i=0;i<rect.height; i++) {
                memcpy(rectData+(i*rect.width), data+((yoffset+rect.height+i)*w+xoffset), rect.width*sizeof(unsigned char));
            }
            // only enable blur barcode recognize on iPhone 3GS and earlier model
            int enable_blur = [MainModel sharedObject].physicalMemory > k256M ? 0 : 1;
            result = hz_ProcessFrame(rectData, rect.width, rect.height, &rect, m_result, &_iBarType, 0, enable_blur);
            free(rectData);
            
        }else{//portrait
            float ratio = (self.fScale -1.0f)/2.0f;
            float scaleWidth = w/self.fScale;
            float scaleHeight = h/self.fScale;
            rect.x = 0;
            rect.y = 0;
            rect.width = scaleWidth*0.6f;
            rect.height = scaleHeight;
            int xoffset = scaleWidth*ratio;
            int yoffset = scaleHeight*ratio;
            unsigned char *rectData = (unsigned  char*)malloc(rect.width*rect.height*sizeof(unsigned char));
            for (int i=0;i<rect.height; i++) {
                memcpy(rectData+(i*rect.width), data+((yoffset+i)*w+xoffset+(int)(scaleWidth/5.0f)), rect.width*sizeof(unsigned char));
            }
            //TODO:-dream, modify library to support scan type
            // only enable blur barcode recognize on iPhone 3GS and earlier model
            int enable_blur = [MainModel sharedObject].physicalMemory > k256M ? 0 : 1;
            result = hz_ProcessFrame(rectData, rect.width, rect.height, &rect, m_result, &_iBarType, 1, enable_blur);
            free(rectData);
        }
        self.strBarcode = [[NSString alloc] initWithCString:m_result encoding:NSUTF8StringEncoding];
        if ( self.strBarcode == nil ) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            self.strBarcode = [[NSString alloc] initWithCString:m_result encoding:enc];
            if ( self.strBarcode == nil )
                self.strBarcode = [NSString stringWithFormat:@"%s" , m_result];
            if ( self.strBarcode == nil )
                self.strBarcode = @"null" ;
        }

        if (result == 2 && self.strBarcode && _iBarType>=8 && _iBarType<=14) {//only product code
            //OSAtomicXor32Barrier(STOPPED ,&state);
            OSAtomicAnd32Barrier(PAUSED, &state);
            UIImage *img = [self creatImage:baseAddress width:w height:h];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(captureReader:didFindProductBarcode:withImage:)]) {
                    [self.delegate captureReader:self didFindProductBarcode:self.strBarcode withImage:img];
                }
            });
        }
    }
    free( data );
    CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);

}


@end
