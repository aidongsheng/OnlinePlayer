//
//  ImageProcess.m
//  wccqr
//
//  Created by dream liu on 12-5-30.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import "ImageProcess.h"
#import "UIImage+Additions.h"

#if WCC_HXCODE
#import "hxcode.h"
#endif

//#import "match.h"

typedef struct HZRECT
{
int x;
int y;
int width;
int height;
}HZRECT;


 hz_ProcessFrame(unsigned char *m_FrameData,int width, int height, HZRECT *m_ActiveRect,char *m_result,int *m_bartype,int rotate_flag, int enable_blur);
 wcc_rainbow_scan(unsigned char *data_rgb, int width, int height, int rotate_flag,unsigned char *debugInfo,unsigned char *code,unsigned char *colorInfor);

//#if !TARGET_IPHONE_SIMULATOR
// EAN13ColorBarDecode(unsigned char *pimg_gray, unsigned char *pimg_r, unsigned char *pimg_g, unsigned char *pimg_b, int width, int height, unsigned char *chResult, unsigned char *colorCode, int *iBartype);
//#endif

@interface ImageProcess ()
@property (nonatomic, strong) NSString *strBarCodeResult;
@property (nonatomic, assign) NSInteger iBarType;

- (NSInteger)decodeImage:(UIImage *)image;
@end

@implementation ImageProcess
@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize strBarCodeResult = _strBarCodeResult;
@synthesize iBarType = _iBarType;

#pragma mark - inside method
- (NSInteger)decodeImage:(UIImage *)image
{
    if ([MainModel sharedObject].bDecodingRainbowImage) {
        return [self decodeBGRImage:image];
    }else{
        return [self decodeGrayImage:image];
    }
}

- (NSInteger)decodeBGRImage:(UIImage*)image
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSUInteger bgrIndex = 0;
    NSUInteger rgbaIndex = 0;
    //    long len = strlen(rawData);
    //    NSLog(@"%ld", len);
    unsigned char* dataBGR = (unsigned char*) calloc(height * width * 3, sizeof(unsigned char));
    for (int i = 0 ; i < width*height ; i++)
    {
        dataBGR[bgrIndex] = rawData[rgbaIndex + 2];
        dataBGR[bgrIndex+1] = rawData[rgbaIndex + 1];
        dataBGR[bgrIndex+2] = rawData[rgbaIndex];
        bgrIndex+= 3*sizeof(unsigned char);
        rgbaIndex += 4*sizeof(unsigned char);
    }
    
    free(rawData);
    char cRainbowResult[100];
    char cRainbowResultColor[100];
    char cRainbowdebugInfo[1025];
    int result = -1111;
    for (int i=0; i<4; i++) {//尝试解码四个方向
        result = wcc_rainbow_scan(dataBGR, (int)width, (int)height, i,cRainbowdebugInfo,cRainbowResult, cRainbowResultColor);
        if (result==0|| result==1 || result==2 || result ==3) {
            break;
        }
    }
    free(dataBGR);
    if (result==0 || result==1 || result==2 || result ==3) {
        self.iBarType = 13;
        NSString *strCode = [self stringByCSString:cRainbowResult];
        NSString *strColor = [self stringByCSString:cRainbowResultColor];
        if (([strColor isEqualToString:@"0"] || [strColor isEqualToString:@"1"])) {
            strColor = @"";
        }
        int i;
        NSString *strDebug=@"";
        for (i=0; i<1025; i++) {
            strDebug  = [NSString stringWithFormat:@"%@,%d",strDebug,cRainbowdebugInfo[i]];
        }
        [MainModel sharedObject].strRainbowDebugInfo = strDebug;
        self.strBarCodeResult = [NSString stringWithFormat:@"%@_%@",strCode, strColor];
    }
    return result;
}

- (NSInteger)decodeGrayImage:(UIImage*)image
{
    CGImageRef cgImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage), 8, CGImageGetWidth(cgImage), colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), cgImage);
    unsigned char *data = CGBitmapContextGetData(bitmapContext);
    HZRECT rect;
    char m_result[5000];
    int result = 0;
    int iBarType;
    rect.x = 0;
    rect.y = 0;
    rect.width = CGImageGetWidth(cgImage);
    rect.height = CGImageGetHeight(cgImage);
    
#if WCC_HXCODE
#define HXCODE_MIN_WIDTH    23
#define HXCODE_MAX_WIDTH    189
#define HXCODE_MAX_HEIGHT   189
#define HXCODE_RESULT_MAX_CHARACTERS   7828
    if ([MainModel sharedObject].m_bHXCodeEnable && data) {
        unsigned char vecNetMap[HXCODE_MAX_WIDTH * HXCODE_MAX_HEIGHT] = {'\0'};
        int vecWidth = preprocessImg(data, rect.width, rect.height, vecNetMap);
        
        if ((HXCODE_MIN_WIDTH <= vecWidth) && (vecWidth <= HXCODE_MAX_WIDTH)) {
            char hx_result[HXCODE_RESULT_MAX_CHARACTERS] = {'\0'};
            int hxResultLength = DeCodeCsbyte(vecNetMap, vecWidth, (unsigned char*)hx_result);
            if (hxResultLength > 0) {
                self.strBarCodeResult = [[NSString alloc] initWithCString:hx_result encoding:NSUTF8StringEncoding];
                if ( self.strBarCodeResult == nil ) {
                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    self.strBarCodeResult = [[NSString alloc] initWithCString:hx_result encoding:enc];
                    if ( self.strBarCodeResult == nil )
                        self.strBarCodeResult = [NSString stringWithFormat:@"%s" , hx_result];
                    if ( self.strBarCodeResult == nil )
                        self.strBarCodeResult = @"null" ;
                }
                if (self.strBarCodeResult) {
                    self.iBarType = HZBAR_HANXIN;
                    result = 2;
                    CGContextRelease(bitmapContext);
                    return result;
                }
            }
        }
    }
#endif
    // only enable blur barcode recognize on iPhone 3GS and earlier model
    int enable_blur = [MainModel sharedObject].physicalMemory > k256M ? 0 : 1;
    result = hz_ProcessFrame(data, rect.width, rect.height, &rect, m_result, &iBarType, 0, enable_blur);
    self.iBarType = iBarType;
    self.strBarCodeResult = [[NSString alloc] initWithCString:m_result encoding:NSUTF8StringEncoding];
    if (self.strBarCodeResult == nil) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        self.strBarCodeResult = [[NSString alloc] initWithCString:m_result encoding:enc];
        if ( self.strBarCodeResult == nil )
            self.strBarCodeResult = [NSString stringWithFormat:@"%s" , m_result];
        if ( self.strBarCodeResult == nil )
            self.strBarCodeResult = @"null" ;
    }

    CGContextRelease(bitmapContext);
    return result;
}

#pragma mark - life cycle
- (id)init
{
    self = [super init];
    if (self) {
        //init
    }
    return self;
}

- (id)initWithImage:(UIImage *)image andDelegate:(id<ImageProcessDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.image = image;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
#if WCC_MEM_CHECK
    NSLog(@"[%@ dealloc]", [self class]);
#endif
}

#pragma mark - public methods
- (void)recognizeBarcode
{
    if (self.image) {
        NSInteger iResult = 0;
        NSInteger iRatio = MAX(self.image.size.width, self.image.size.height)/450.0f;//if the size of the image is too large then resize it to small
        if (iRatio>1) {
            self.image = [self.image getScaledImage:1.0f/iRatio];
        }
        iResult = [self decodeImage:self.image];
        if (([MainModel sharedObject].bDecodingRainbowImage&&iResult !=0 && iResult !=1 && iResult!=2&&iResult!=3) || (![MainModel sharedObject].bDecodingRainbowImage && iResult!=2)) {//make one more attempt for half size of the image
            UIImage *halfImage = [self.image getScaledImage:0.5f];
            iResult = [self decodeImage:halfImage];
        }
#if WCC_TEST_VERSION
        NSLog(@"result:%d", iResult);
#endif
        if ((([MainModel sharedObject].bDecodingRainbowImage &&(iResult ==0 || iResult ==1 || iResult ==2 || iResult ==3)) || (![MainModel sharedObject].bDecodingRainbowImage && iResult ==2)) && self.strBarCodeResult) {
#if WCC_TEST_VERSION
            NSLog(@"recognize success:%@",self.strBarCodeResult);
#endif
            if (self.delegate && [self.delegate respondsToSelector:@selector(didRecognizeBarcode:withType:inImage:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate didRecognizeBarcode:self.strBarCodeResult withType:self.iBarType inImage:self.image];
                });
            }
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(failedToRecognizeBarcode)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate failedToRecognizeBarcode];
            });
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(failedToRecognizeBarcode)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate failedToRecognizeBarcode];
            });
        }
    }
}

- (NSString*)stringByCSString:(const char*)csString
{
    NSString *strReturn = [[NSString alloc]initWithCString:csString encoding:NSUTF8StringEncoding];
    if ( strReturn == nil ) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        strReturn = [[NSString alloc] initWithCString:csString encoding:enc];
        if ( strReturn == nil )
            strReturn = [NSString stringWithFormat:@"%s" , csString];
    }
    strReturn = strReturn==nil ? @"null" : strReturn;
    return strReturn;
}


@end
