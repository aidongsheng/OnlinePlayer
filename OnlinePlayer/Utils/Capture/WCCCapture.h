//
//  WCCCapture.h
//  wochacha
//
//  Created by dream liu on 13-5-7.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVCaptureSession,AVCaptureDeviceInput,AVCaptureDevice,AVCaptureOutput;

@interface WCCCapture : NSObject

@property(nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property(nonatomic, strong, readonly) AVCaptureDevice *captureDevice;
@property(nonatomic, strong, readonly) AVCaptureDeviceInput *captureDeviceInput;

@property(nonatomic, assign) AVCaptureTorchMode torchMode;

- (void)removeCaptureOutput:(AVCaptureOutput *)output;
- (void)addCaptureOutput:(AVCaptureOutput *)output;

@end
