//
//  WCCCapture.m
//  wochacha
//
//  Created by dream liu on 13-5-7.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "WCCCapture.h"
#import <Foundation/NSProcessInfo.h>


@implementation WCCCapture
@synthesize
captureSession = _captureSession,
captureDevice = _captureDevice,
captureDeviceInput = _captureDeviceInput,
torchMode = _torchMode;

#pragma mark - getter & setter
- (AVCaptureTorchMode)torchMode
{
    return _torchMode;
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode
{
    [_captureDevice lockForConfiguration:nil];
    if ([_captureDevice  isTorchModeSupported:torchMode]) {
        [_captureDevice setTorchMode:torchMode];
        _torchMode = torchMode;
    }
    [_captureDevice unlockForConfiguration];
}

#pragma mark - life cycle
- (id)init
{
    self = [super init];
    if (self) {
        //create capture session
        _captureSession = [AVCaptureSession new];
        //add observer for session
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoError:) name:AVCaptureSessionRuntimeErrorNotification object:_captureSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoStart:) name:AVCaptureSessionDidStartRunningNotification object:_captureSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoStop:) name:AVCaptureSessionDidStopRunningNotification object:_captureSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoStop:) name:AVCaptureSessionWasInterruptedNotification object:_captureSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoStart:) name:AVCaptureSessionInterruptionEndedNotification object:_captureSession];
        //create capture device & capture devie input
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
//        _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        if ( (!_captureDeviceInput || error != nil) && !TARGET_IPHONE_SIMULATOR )
        {
            // AVErrorApplicationIsNotAuthorizedToUseDevice
//            NSLog(@"ERROR : trying to open camera : %@", error);
            NSString *strError = [NSString stringWithFormat:@"请在【设置->隐私->相机】下\n允许“我查查”访问相机"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"使用提示" message:strError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show] ;
        }
        
        //add input to capture session
        if ([_captureSession canAddInput:_captureDeviceInput]) {
            [_captureSession addInput:_captureDeviceInput];
        }
        //config capture session
        [_captureSession beginConfiguration];
        NSUInteger pm = [MainModel sharedObject].physicalMemory;
        // TODO-Alen enable 1080p on specified devices
        if (NO && [_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
        } else if (pm > k512M && [_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
        } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {//iPhone 3G can't support AVCaptureSessionPreset640x480
            [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        } else {
            // TODO-Alen Default case
        }
        //commit configuration
        [_captureSession commitConfiguration];
        _torchMode = AVCaptureTorchModeOff;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.captureSession removeInput:self.captureDeviceInput];//Important: 100% crash in iOS<4.1
}

#pragma mark - notification of capture session
- (void)onVideoError:(NSNotification *) notification
{
    [self.captureDevice unlockForConfiguration];
    NSError *error = [notification.userInfo objectForKey:AVCaptureSessionErrorKey];
    NSLog(@"WCCCaptureView:ERROR during capture:%@: %@",[error localizedDescription],[error localizedFailureReason]);
}

- (void)onVideoStart:(NSNotification *) notification
{
    NSError *error = nil;
    if ([self.captureDevice lockForConfiguration:&error]) {
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            if ([self.captureDevice isFocusPointOfInterestSupported]) {
                [self.captureDevice setFocusPointOfInterest:CGPointMake(0.49f, 0.49f)];
            }
            [self.captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        if ([self.captureDevice isTorchModeSupported:_torchMode]) {
            [self.captureDevice setTorchMode:_torchMode];
        }
        if ( [self.captureDevice respondsToSelector:@selector(isAutoFocusRangeRestrictionSupported)] ) {
            if ([self.captureDevice isAutoFocusRangeRestrictionSupported]) {
                //new in ios7, to make the iPhone5S device to focus on near distance 
                [self.captureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
            }
        }
    }
}

- (void)onVideoStop:(NSNotification *) notification
{
    [self.captureDevice unlockForConfiguration];
}


#pragma mark - public method
- (void)addCaptureOutput:(AVCaptureOutput *)output
{
    [_captureSession beginConfiguration];
    if ([_captureSession canAddOutput:output]) {
        [_captureSession addOutput:output];
    }
//    if ([MainModel sharedObject].bNewThaniPhone4) {
//        [[output connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
//    }
    [_captureSession commitConfiguration];
}

- (void)removeCaptureOutput:(AVCaptureOutput *)output
{
    [_captureSession beginConfiguration];
    [_captureSession removeOutput:output];
    [_captureSession commitConfiguration];
}

@end



