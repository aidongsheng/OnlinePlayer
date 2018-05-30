//
//  WCCCaptureReaderDelegate.h
//  WccRMBDemo
//
//  Created by dream liu on 12-11-21.
//  Copyright (c) 2012年 dream liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCCCaptureReader;

@protocol WCCCaptureReaderDelegate <NSObject>

@optional
//RMB
- (void)captureReader:(WCCCaptureReader *)reader didRecognizeRMBValue:(NSInteger)iValue snNumber:(NSString *)strSN andResult:(NSInteger)iResult;//0: fake 1:real
//Barcode
- (void)captureReader:(WCCCaptureReader *)reader didFindBarcode:(NSString *)strBarcode withType:(NSInteger) iBarType andImage:(UIImage *)image;
//cart
- (void)captureReader:(WCCCaptureReader *)reader didFindProductBarcode:(NSString *)strBarcode withImage:(UIImage *)image;
//Chaoshi
- (void)captureReader:(WCCCaptureReader *)reader didFindCSGoodsBarcode:(NSString *)strBarcode withImage:(UIImage *)image;

//License Plate
- (void)captureReader:(WCCCaptureReader *)reader didFindLicensePlate:(NSString *)strPlate withImage:(UIImage *)image;

//Plate Timeout
- (void)captureReader:(WCCCaptureReader *)reader didCancel:(NSString *)strMessage;

- (void)shouldOpenFlushWithCaptureReader:(WCCCaptureReader *)reader;
@end
