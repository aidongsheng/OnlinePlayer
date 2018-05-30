//
//  WCCCaptureBarcodeReader.m
//  wochacha
//
//  Created by dream liu on 13-5-7.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <libkern/OSAtomic.h>
#import "WCCCaptureBarcodeReader.h"
#if WCC_HCODE
//#import "DecodeMotheds.h"
#endif

#if WCC_HXCODE
#import "hxcode.h"
#define HXCODE_MIN_WIDTH    23
#define HXCODE_MAX_WIDTH    189
#define HXCODE_MAX_HEIGHT   189
#define HXCODE_RESULT_MAX_CHARACTERS   7828
#endif

#if WCC_MATCH
#import "match.h"
static int logoMatch(unsigned char *data, int iWidth, int iHeight)
{
    ccmatch_result_t res;
    ccmatch_config_t mcfg;
    void *ctx;
    //set parameters
    mcfg.logo_thrH = 15;
    mcfg.logo_thrL = 6;
    mcfg.match_type = LOGO_MATCH;
    mcfg.imgdbl = 0;
    mcfg.data = NULL;
    mcfg.min_oct = 2;
    mcfg.intvls = 3;
    
    ctx = init_match(&mcfg);
    if (ctx == 0L) {
        NSLog(@"init match failed.");
        return -1;
    }
    //down sampling
    int dsRatio = 4;
    int dsWidth = iWidth/dsRatio;
    int dsHeight = iHeight/dsRatio;
    char *dsData = (char *)malloc(sizeof(char)*dsWidth*dsHeight);
    int index = 0;
    for (int i=0; i<iHeight; i+=dsRatio) {
        for (int j=0; j<iWidth; j+=dsRatio) {
            dsData[index++] = data[i*iWidth+j];
        }
    }
    if (!logomatch(ctx, dsData, dsWidth, dsHeight, &res)) {
        free(dsData);
        end_match(ctx);
        return res.match;
    }
    free(dsData);
    end_match(ctx);
    return -1;
}
#endif

typedef struct HZRECT
{
    int x;
    int y;
    int width;
    int height;
}HZRECT;


 hz_ProcessFrame(unsigned char *m_FrameData,int width, int height, HZRECT *m_ActiveRect,char *m_result,int *m_bartype,int rotate_flag, int enable_blur);
 wcc_rainbow_scan(unsigned char *data_rgb, int width, int height, int rotate_flag,unsigned char *debugInfo,unsigned char *code,unsigned char *colorInfor);

//控制闪光灯：原理：统计图像灰度信息的均值，与设定阈值（thresh经验值为30）比较，若低于阈值，需要开启闪光灯，返回1；若高于阈值，不需要开启闪光灯，返回0。
#if !TARGET_IPHONE_SIMULATOR
 flashControl(unsigned char *pimgy, unsigned char *r, unsigned char *g, unsigned char *b, int width, int height, int thresh);
#endif

@interface WCCCaptureBarcodeReader ()
{
    int iTimes;
}

@property(nonatomic, strong) NSString *strBarcode;
@property(nonatomic, assign) int iBarType;
@property(nonatomic, assign) BOOL bOpenFlush;
//@property(nonatomic, assign) BOOL bColorfull;
@property(nonatomic, assign) int iNeedFlush;
@end

@implementation WCCCaptureBarcodeReader
@synthesize
strBarcode = _strBarcode,
iBarType = _iBarType;
#pragma mark - 对象生命周期
- (id)init
{
    self = [super init];
    if (self) {
        //set captureOutput property
        self.captureOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
        iTimes = 0;
#if WCC_HCODE
//        if ([MainModel sharedObject].m_bHCodeEnable) {
//            [[DecodeMotheds sharedInstance] startDecodeThread];
//        }
#endif
        self.bRainbowEnable =NO;
//        self.bColorfull = NO;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
#if WCC_HCODE
//    if ([MainModel sharedObject].m_bHCodeEnable && [[DecodeMotheds sharedInstance] checkHasValid]) {
//        [[DecodeMotheds sharedInstance] closeDecodeThread];
//    }
#endif
}

#pragma mark - 解码：数据处理及算法调度
- (void)recognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
//    self.bColorfull = NO;
    BOOL bRainbowEnable = self.bRainbowEnable;
    
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
    int iWidth = (int)iFrameWidth;
    int iHeight = (int)iFrameHeight;
    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(buf);
    
    // 如果扫描彩虹码，则启动彩虹码识别算法 Hayden Add @ 2015.08.20 v8.3
    if (bRainbowEnable) {
       [self decodeRainbowData:baseAddress width:iWidth height:iHeight];
       CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
        return;
    }
    // 预处理数据
    BOOL bDecodeSuccess = NO;
    uint8_t *data = NULL;
    unsigned char* rectData = NULL;
    [self convertBaseData:baseAddress toBGRData:&data withWidth:iWidth height:iHeight];
    HZRECT rect = [self rectByConvertBGRData:data toRectData:&rectData withWidth:iWidth andHeight:iHeight];
    // 开始进行混合解码，包括普通EN13条码、QRCode和快递码等

#if WCC_MATCH
    // 匹配码解码
    NSLog(@"匹配码解码开始");
    bDecodeSuccess = [self decodeMatchBaseData:baseAddress convData:data width:iWidth height:iHeight];
    if (bDecodeSuccess) {
        NSLog(@"匹配码识别成功");
        free( data );
        free( rectData );
        CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
        return;
    }
#endif
    
#if WCC_HXCODE
    // 汉信码解码
    NSLog(@"汉信码解码开始");
    bDecodeSuccess = [self decodeHXCodeBaseData:baseAddress rectData:rectData width:rect.width height:rect.height baseWidth:iWidth baseHeight:iHeight];
    if (bDecodeSuccess) {
        NSLog(@"汉信码识别成功");
        free( data );
        free( rectData );
        CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
        return;
    }
#endif
    
    NSLog(@"混合码解码开始");
    bDecodeSuccess = [self decodeMixBaseData:baseAddress baseWidth:iWidth baseHeight:iHeight rectData:rectData rect:rect rainbowEnabled:bRainbowEnable];
    if (bDecodeSuccess) {
        NSLog(@"混合码识别成功");
        free( data );
        free( rectData );
        CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
        return;
    }
    
    free( data );
    free( rectData );
    
    CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
}

//#pragma mark - inside methods
//- (BOOL)bInRainBowList:(NSString *)strCode
//{
//    NSArray *arrRainBow = [MainModel sharedObject].arrRainBow;
//    for (NSString *strRainCode in arrRainBow) {
//        if ([strRainCode isEqualToString:strCode]) {
//            NSLog(@"扫描到EAN13并且是彩虹码");
//            return YES;
//        }
//    }
//    return NO;
//}

#pragma mark - 解码算法
/**
 *  彩虹码模糊解码
 *
 *  @param rectDataForBlur   去掉灰度并剪裁后的BGR图像数据
 *  @param iRectWidth        rectDataForBur图像数据的宽度
 *  @param iRectHeight       rectDataForBur图像数据的高度
 *  @param baseData          原始的BGRA图像数据
 *  @param iBaseWith         baseData图像数据的宽度
 *  @param iBaseHeight       baseData图像数据的高度
 *
 */
- (void)decodeRainbowDataForFlush:(uint8_t*)rectDataForBlur width:(int)iRectWidth height:(int)iRectHeight baseWidth:(int)iBaseWith andbaseHeight:(int)iBaseHeight{
    uint8_t *dataTempR = malloc(iRectHeight*iRectWidth*sizeof(uint8_t));
    uint8_t *dataTempG = malloc(iRectHeight*iRectWidth*sizeof(uint8_t));
    uint8_t *dataTempB = malloc(iRectHeight*iRectWidth*sizeof(uint8_t));
    //从BGR图像数据中，取出B、G、R三个数据，分别保存
    int n=0;
    for (int j=1; j<=iRectWidth; j++){
        for (int i=iRectHeight; i>0; i--) {
            dataTempB[n] = rectDataForBlur[n*3+0];
            dataTempG[n] = rectDataForBlur[n*3+1];
            dataTempR[n] = rectDataForBlur[n*3+2];
            n++;
        }
    }
#if !TARGET_IPHONE_SIMULATOR
    _iNeedFlush = flashControl(0, dataTempR, dataTempG, dataTempB, iRectWidth, iRectHeight, 20);
#endif
    free(dataTempR);
    free(dataTempG);
    free(dataTempB);

}

/**
 *  彩虹码解码
 *
 *  @param rectData          去掉灰度并剪裁后的BGR图像数据
 *  @param iRectWidth        rectDataForBur图像数据的宽度
 *  @param iRectHeight       rectDataForBur图像数据的高度
 *  @param baseData          原始的BGRA图像数据
 *  @param iBaseWith         baseData图像数据的宽度
 *  @param iBaseHeight       baseData图像数据的高度
 *
 */
- (void)decodeRainbowData:(uint8_t*)rectData width:(int)iRectWidth height:(int)iRectHeight baseRGBData:(uint8_t*)baseData baseWidth:(int)iBaseWith andbaseHeight:(int)iBaseHeight{
    // 初始化解码结果存储变量
    int rainbowResult = 0;
    char cRainbowResult[100];
    char cRainbowResultColor[100];
    char cRainbowdebugInfo[1025];
    int iRotate_flag = 1;
    
    switch (self.orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            iRotate_flag = 2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            iRotate_flag = 0;
            break;
        default:
            iRotate_flag = 1;
            break;
    }
    
//    [self getImageForBitmapWithBGRData:rectData width:iRectWidth height:iRectHeight];
    rainbowResult = wcc_rainbow_scan(rectData, iRectWidth, iRectHeight, iRotate_flag,cRainbowdebugInfo,cRainbowResult,cRainbowResultColor);
    NSLog(@"彩虹码识别结果result:%d rotate=%d",rainbowResult,iRotate_flag);
    //rectdata_iwidth_iheight_result_i其中i代表用彩虹码算法解码的次数
//    NSString *strPath = [NSString stringWithFormat:@"rectdata_%d_%d_%d_%d_%d.txt",iRectWidth,iRectHeight,iRotate_flag,rainbowResult,iTimes++];
//    NSString *filePath = [[FilePathHelper documentFilePath] stringByAppendingPathComponent:strPath];
//    NSLog(@"rectData path:%@",filePath);
//    FILE *fp = fopen([filePath UTF8String], "wb");
//    if(fp){fwrite(rectData, 1, 3*iRectWidth * iRectHeight, fp);
//        fclose(fp);}
//
    if (rainbowResult!=0 &&rainbowResult!=1&&rainbowResult!=2&&rainbowResult!=3) {
    for (int i=3; i>-1; i--) {
            if (i != iRotate_flag) {
                rainbowResult = wcc_rainbow_scan(rectData, iRectWidth, iRectHeight, i,cRainbowdebugInfo,cRainbowResult,cRainbowResultColor);
                if (rainbowResult==0 || rainbowResult==1 || rainbowResult==2 || rainbowResult==3)
//                if((rainbowResult & 0xF0) == 0)
                break;
                
            }
        }
    }
    
    // 处理解码结果，如果解码成功，则获取数据并退出视频捕捉
    if (rainbowResult==0 ||rainbowResult==1|| rainbowResult==2 || rainbowResult==3) {
//if((rainbowResult&0xF0)==0){
        [self handleTheSuccessReslutDataWithBarcode:cRainbowResult rainbowCode:cRainbowResultColor rainBowDebugInfo:cRainbowdebugInfo baseRGBA:baseData baseWidth:iBaseWith BaseHeight:iBaseHeight];
        NSLog(@"rainBow识别成功");
    }
}

/**
 *  彩虹码解码预处理
 *
 *  @param baseData 基础数据，数据排列为BGRA
 *  @param iWidth   像素宽度
 *  @param iHeight  像素高度
 *
 */
- (void)decodeRainbowData:(uint8_t*)baseData width:(int)iWidth height:(int)iHeight
{
    // 原始数据排布为BGRA，为4通道
    int iBytesPerPixel = 4*sizeof(unsigned char);
    // 去除Alpha通道
    int iRainbowChannel = 3;
    unsigned char* dataColorful = malloc(iWidth*iHeight*sizeof(uint8_t)*iRainbowChannel);
    for (int i=0; i<iWidth*iHeight; i++) {
        memcpy(dataColorful+i*iRainbowChannel, baseData+i*iBytesPerPixel, iRainbowChannel*sizeof(unsigned char));
    }
    
    // 根据缩放截取数据
    float fScale = self.fScale;
    float ratio = (fScale -1.0f)/2.0f;
    float scaleWidth = iWidth/fScale;
    float scaleHeight = iHeight/fScale;
    
    //590*553
    int rectWidth = scaleWidth*0.6f;
    int rectHeight = scaleHeight;
    
    int xoffset = scaleWidth*ratio;
    int yoffset = scaleHeight*ratio;
    
    int iLength = iRainbowChannel * rectWidth * rectHeight * sizeof(unsigned char) ;
    unsigned char *rectData = (unsigned  char*)malloc(iLength);

    for (int i=0;i<rectHeight; i++) {
        memcpy(rectData+(i*rectWidth*3), dataColorful+3*((yoffset+i)*iWidth+xoffset+(int)(scaleWidth/5.0f)), rectWidth*3*sizeof(unsigned char));
    }
    
    dispatch_queue_t rainBowDecode = dispatch_queue_create("rainBowDecode", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t rainBowDecodeAndFlush = dispatch_group_create();
    dispatch_group_async(rainBowDecodeAndFlush, rainBowDecode, ^{
        dispatch_group_enter(rainBowDecodeAndFlush);
        NSLog(@"闪光灯算法开始");
        [self decodeRainbowDataForFlush:rectData width:rectWidth height:rectHeight baseWidth:iWidth andbaseHeight:iHeight];
        dispatch_group_leave(rainBowDecodeAndFlush);
        NSLog(@"闪光灯结束");
    });
    dispatch_group_async(rainBowDecodeAndFlush, rainBowDecode, ^{
        dispatch_group_enter(rainBowDecodeAndFlush);
         NSLog(@"彩虹码算法开始");
           [self decodeRainbowData:rectData width:rectWidth height:rectHeight baseRGBData:baseData baseWidth:iWidth andbaseHeight:iHeight];
        dispatch_group_leave(rainBowDecodeAndFlush);
        NSLog(@"彩虹码算法结束");
    });
    dispatch_group_wait(rainBowDecodeAndFlush, DISPATCH_TIME_FOREVER);
    NSLog(@"所有彩虹码算法和闪光灯完成");
    // 解码结束，释放用于彩虹码识别算法的资源
    free(rectData);
    free(dataColorful);
}

/**
 *  混合解码，包括普通EN13条码，QRCode，快递码，药监码等
 *
 *  @param baseData 基础数据，数据排列为BGRA
 *  @param iWidth   基础数据像素宽度
 *  @param iHeight  基础数据像素高度
 *  @param rectData 根据缩放比例和屏幕方向裁剪图像所得数据，数据排列为BGR
 *  @param rect     裁剪区域
 *  @param enable   是否启用了彩虹码识别，如果启用了彩虹码解码，则排除EN13解码
 *
 *  @return 是否解码成功
 */
- (BOOL)decodeMixBaseData:(uint8_t*) baseData baseWidth:(int)iWidth baseHeight:(int)iHeight rectData:(unsigned char*)rectData rect:(HZRECT)rect rainbowEnabled:(BOOL)enable
{
    int iRotate_flag = self.orientation == UIInterfaceOrientationPortrait ? 1 : 0;
    int result = 0;
    char m_result[5000];
    // only enable blur barcode recognize on iPhone 3GS and earlier model
    int enable_blur = [MainModel sharedObject].physicalMemory > k256M ? 0 : 1;
//    int i, j;
//    unsigned char *tmpPTR = rectData;
//    NSString *filePath = [[FilePathHelper documentFilePath] stringByAppendingPathComponent:@"rectData.txt"];
//        NSLog(@"rectData path:%@",filePath);
//    FILE *fp = fopen([filePath UTF8String], "wb");
//    if(fp){fwrite(rectData, 1, rect.width * rect.height, fp);
//        fclose(fp);}
//    printf("\n************************\n");
//    for(i = 0; i < rect.height; ++i)
//    {
//        for(j = 0; j < rect.width; ++j)
//        {
//            int tmp;
//            tmp = *tmpPTR++;
//            printf("%d\t", tmp);
//        }
//    }
    result = hz_ProcessFrame(rectData, rect.width, rect.height, &rect, m_result, &_iBarType, iRotate_flag, enable_blur);

    // 如果开启了彩虹码，则不使用zbar解析出的EN13
    BOOL bSuccess = (result == 2);
    if (bSuccess) {
        self.strBarcode = [self stringByCSString:m_result];
//        if (self.bColorfull) {
//            return NO;
//        }
        OSAtomicXor32Barrier(PAUSED ,&state);
        UIImage *img = [self creatImage:baseData width:iWidth height:iHeight];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(captureReader:didFindBarcode:withType:andImage:)]) {
                [self.delegate captureReader:self didFindBarcode:self.strBarcode withType:self.iBarType andImage:img];
            }
        });
        return YES;
    }
    return NO;
}

#if WCC_MATCH
/**
 *  匹配码解码
 *
 *  @param baseData 基础数据，数据排列为BGRA
 *  @param data     转换为BGR排列的图像数据
 *  @param iWidth   像素宽度
 *  @param iHeight  像素高度
 *
 *  @return 是否解码成功
 */
- (BOOL)decodeMatchBaseData:(uint8_t*)baseData convData:(unsigned char*)data width:(int)iWidth height:(int)iHeight
{
    int iLogo = -1;
    iLogo = logoMatch(data, iWidth, iHeight);
    if (iLogo >=0 && iLogo < 13) {
        self.iBarType = HZ_MATCH;
        self.strBarcode = [NSString stringWithFormat:@"%d",iLogo];
        OSAtomicXor32Barrier(PAUSED ,&state);
        UIImage *img = [self creatImage:baseData width:iWidth height:iHeight];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(captureReader:didFindBarcode:withType:andImage:)]) {
                [self.delegate captureReader:self didFindBarcode:self.strBarcode withType:self.iBarType andImage:img];
            }
        });
        return YES;
    }
    return NO;
}
#endif

#if WCC_HXCODE
/**
 *  汉信码解码
 *
 *  @param baseData 基础数据，数据排列为BGRA
 *  @param data     根据缩放比例和屏幕方向裁剪图像所得数据，数据排列为BGR
 *  @param iWidth   裁剪区域像素宽度
 *  @param iHeight  裁剪区域像素高度
 *
 *  @return 是否解码成功
 */

- (BOOL)decodeHXCodeBaseData:(uint8_t*)baseData rectData:(unsigned char*)data width:(int)iWidth height:(int)iHeight baseWidth:(int)baseWidth baseHeight:(int)baseHeight
{
    if ([MainModel sharedObject].m_bHXCodeEnable && data) {
        unsigned char vecNetMap[HXCODE_MAX_WIDTH * HXCODE_MAX_HEIGHT] = {'\0'};
        int vecWidth = preprocessImg(data, iWidth, iHeight, vecNetMap);
        
        if ((HXCODE_MIN_WIDTH <= vecWidth) && (vecWidth <= HXCODE_MAX_WIDTH)) {
            char hx_result[HXCODE_RESULT_MAX_CHARACTERS] = {'\0'};
            int hxResultLength = DeCodeCsbyte(vecNetMap, vecWidth, (unsigned char*)hx_result);
            if (hxResultLength > 0) {
                self.strBarcode = [self stringByCSString:hx_result];
                self.iBarType = HZBAR_HANXIN;
                OSAtomicXor32Barrier(PAUSED ,&state);
                UIImage *img = [self creatImage:baseData width:baseWidth height:baseHeight];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(captureReader:didFindBarcode:withType:andImage:)]) {
                        [self.delegate captureReader:self didFindBarcode:self.strBarcode withType:self.iBarType andImage:img];
                    }
                });
                return YES;
            }
        }
    }
    return NO;
}
#endif

#pragma mark - 数据转换
/**
 *  将基础数据（BGRA）转化为数据（BGR）
 *
 *  @param baseData 基础数据，数据排列为BGRA
 *  @param data     转换后的数据指向，数据排列为BGR
 *  @param iWidth   像素宽度
 *  @param iHeight  像素高度
 */
- (void)convertBaseData:(uint8_t*)baseData toBGRData:(unsigned char**)data withWidth:(int)iWidth height:(int)iHeight
{
    uint8_t *dataTemp = malloc(iWidth*iHeight*sizeof(uint8_t));
    OSAtomicAdd32(1, &channel);
    int iChannel =channel & 0x0003;
    //iChanel 0-Blue 1-Green 2-Red 3-Gray
    if (iChannel == 3) {
        for (int i=0; i<iWidth*iHeight; i++)//pixel format is BGRA
            dataTemp[i] = baseData[i*4]*0.072169 + baseData[i*4+1]*0.71516 + baseData[i*4+2]*0.212671;
    }else{
        for (int i=0; i<iWidth*iHeight; i++)
            dataTemp[i] = baseData[i*4+iChannel];
    }
    *data = dataTemp;
}

/**
 *  根据缩放比例和屏幕方向裁剪图像，并返回裁剪区域
 *
 *  @param data     转化为BGR排列的图像数据
 *  @param rectData 裁剪后的数据指向
 *  @param iWidth   未裁剪的图像像素宽度
 *  @param iHeight  未裁剪的图像像素高度
 *
 *  @return 裁剪区域
 */
- (HZRECT)rectByConvertBGRData:(unsigned char*)data toRectData:(unsigned char**)rectData withWidth:(int)iWidth andHeight:(int)iHeight
{
    unsigned char* rectDataTemp = NULL;
    HZRECT rect;
    if (data) {
        CGFloat scale = self.fScale;
        if (self.orientation == UIInterfaceOrientationLandscapeLeft || self.orientation == UIInterfaceOrientationLandscapeRight) {
            float ratio = (scale -1.0f)/2.0f;
            float scaleWidth = iWidth/scale;
            float scaleHeight = iHeight/scale;
            rect.x = 0;
            rect.y = 0;
            rect.width = scaleWidth;
            rect.height = scaleHeight/3.0f+1;
            int xoffset = scaleWidth*ratio;
            int yoffset = scaleHeight*ratio;
            rectDataTemp = (unsigned  char*)malloc(rect.width*rect.height*sizeof(unsigned char));
            for (int i=0;i<rect.height; i++) {
                memcpy(rectDataTemp+(i*rect.width), data+((yoffset+rect.height+i)*iWidth+xoffset), rect.width*sizeof(unsigned char));
            }
        }else{//portrait
            float ratio = (scale -1.0f)/2.0f;
            float scaleWidth = iWidth/scale;
            float scaleHeight = iHeight/scale;
            rect.x = 0;
            rect.y = 0;
            rect.width = scaleWidth*0.6f;
            rect.height = scaleHeight;
            int xoffset = scaleWidth*ratio;
            int yoffset = scaleHeight*ratio;
            rectDataTemp = (unsigned  char*)malloc(rect.width*rect.height*sizeof(unsigned char));
            for (int i=0;i<rect.height; i++) {
                memcpy(rectDataTemp+(i*rect.width), data+((yoffset+i)*iWidth+xoffset+(int)(scaleWidth/5.0f)), rect.width*sizeof(unsigned char));
            }
        }
    }
    *rectData = rectDataTemp;
    return rect;
}

/**
 *  将const char*转换为NSString
 *
 *  @param csString 源数据（const char*）
 *
 *  @return 转换后的字符串
 */
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

/**
 *  处理解码成功后的数据
 *
 *  @param cRainbowResult        算法解析出来的barCode
 *  @param cRainbowResultColor   算法解析出来的colorCode
 *  @param baseData              原始的BGRA图像数据
 *  @param iWidth                baseData的宽度
 *  @param iHeight               baseData的高度
 *  @param iType
 *
 *
 */
- (void)handleTheSuccessReslutDataWithBarcode:(char*)cRainbowResult rainbowCode:(char*)cRainbowResultColor rainBowDebugInfo:(char*)cDebugInfo baseRGBA:(uint8_t *)baseData baseWidth:(int)iWidth BaseHeight:(int)iHeight
{
    NSString *strCode = [self stringByCSString:cRainbowResult];
    NSString *strColorInfo = [self stringByCSString:cRainbowResultColor];
    NSLog(@"识别出的ColorINFO:%@",strColorInfo);
    int i;
    NSString *strDebug=@"";
    for (i=0; i<1025; i++) {
      strDebug  = [NSString stringWithFormat:@"%@,%d",strDebug,cDebugInfo[i]];
    }
    [MainModel sharedObject].strRainbowDebugInfo = strDebug;

//    NSArray *arrRainBow = [MainModel sharedObject].arrRainBow;
    //9.1此模式下如果识别成单色或知道是彩色但是没彩色码，那么处理逻辑是，先看是不是光线暗并且是第一次打开闪光灯，如果是那么打开闪光灯后重新扫描，如果不是，如果确认有彩色信息，那么就直接返回重新扫描，如果是单色就直接过掉
        if (([strColorInfo isEqualToString:@"0"] || [strColorInfo isEqualToString:@"1"])) {
            if (_iNeedFlush && !_bOpenFlush) {
                _bOpenFlush = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate shouldOpenFlushWithCaptureReader:self];
                });
                return;
            }
            
            if ([strColorInfo isEqualToString:@"1"]) {
                return;
            }
        }
    
    if ([strColorInfo isEqualToString:@"0"]) {
        strColorInfo = @"";
    }
    self.strBarcode = [NSString stringWithFormat:@"%@_%@",strCode,strColorInfo];
    OSAtomicXor32Barrier(PAUSED ,&state);
    UIImage *img = [self creatImage:baseData width:iWidth height:iHeight];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(captureReader:didFindBarcode:withType:andImage:)]) {
            [self.delegate captureReader:self didFindBarcode:self.strBarcode withType:13 andImage:img];
        }
    });
}


/**
 *  检测灰度图是否正确(测试用)
 *
 *  @param dataTemp    灰度图数据
 *  @param iWidth      dataTmp的宽度
 *  @param iHeight     dataTmp的高度
 *
 *  @description 图像结果会保存到相册里
 */
- (void)getImageForBitmapWithData:(uint8_t *)dataTemp width:(int)iWidth height:(int)iHeight{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, dataTemp, (iWidth*iHeight), NULL);
        CGImageRef cgImage = CGImageCreate(iWidth,iHeight, 4, 8, iWidth, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst, provider, NULL, true, kCGRenderingIntentDefault);
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    
        CGColorSpaceRelease(colorSpace);
        CGDataProviderRelease(provider);
        CGImageRelease(cgImage);
    
        // 直接释放imgData会导致创建好的image丢失数据，因此先转换为NSData再实例化
        NSData *dataImg = UIImageJPEGRepresentation(image, 1);
        image = [[UIImage alloc]initWithData:dataImg];
    
        // 写入相册
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

/**
 *  检测BGR图是否正确(测试用)
 *
 *  @param dataTemp    BGR图数据
 *  @param iWidth      dataTmp的宽度
 *  @param iHeight     dataTmp的高度
 *
 *  @description 图像结果会保存到相册里
 */
- (void)getImageForBitmapWithBGRData:(uint8_t *)pImgRGB width:(int)iw height:(int)ih{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        return;
    }
    //    int iBytesPerPixelRGB = 3 ;     // Source
    int iBytesPerPixelRGBA = 4 ;    // Destination
    int iwidth = iw;
    int iheight = ih;
    int iLength = iw * ih ;
    unsigned char *pImgRGBA = malloc(iLength*iBytesPerPixelRGBA);
    if ( pImgRGBA == nil ) return ;
    
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
    
    // 直接释放imgData会导致创建好的image丢失数据，因此先转换为NSData再实例化
    NSData *dataImg = UIImageJPEGRepresentation(image, 1);
    image = [[UIImage alloc]initWithData:dataImg];
    
    // 写入相册
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}
@end
