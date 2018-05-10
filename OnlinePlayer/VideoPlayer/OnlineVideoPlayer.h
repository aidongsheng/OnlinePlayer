//
//  OnlineVideoPlayer.h
//  wochacha
//
//  Created by wcc on 2018/4/24.
//  Copyright © 2018年 wochacha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoDownloader;

@protocol OnlineVideoPlayerDelegate <NSObject>
@optional

/**
 开始播放/视频曝光统计
 */
- (void)didStartVideoPlayer;

/**
 结束播放代理方法
 */
- (void)didStopVideoPlayer;

/**
 暂停播放代理方法
 */
- (void)didPauseVideoPlayer;

/**
 视频画面被点击代理方法
 */
- (void)didTapedVideoPlayer;

/**
 确实中断了视频广告的播放的回调
 
 @param playedTime 已经播放出来的时长
 */
- (void)didInterruptADPlaying:(float)break_time;

/**
 播放器关闭按钮被点击事件
 */
- (void)playerCloseButtonBeClicked;

/**
 非WiFi环境，且本地无对应 URL 的缓存文件，则直接关闭 StartUpADViewController
 */
- (void)closeStartADController;
@end

@interface OnlineVideoPlayer : UIView<NSURLSessionDataDelegate,NSURLConnectionDataDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, assign) float currentTime;    //  已播放时长
@property (nonatomic, assign) float totalDuration;  //  视频总时长
@property (nonatomic, weak)   id<OnlineVideoPlayerDelegate>delegate;

- (instancetype)initWithVideoUrl:(NSString *)videoUrl delegate:(id<OnlineVideoPlayerDelegate>)delegate;

- (void)playerVideoWithUrl:(NSString *)videoUrl;

/**
 判断对应 videourl 的本地视频文件是否存在
 
 @param videoUrl 视频链接地址
 @return 是否存在的标识
 */
- (BOOL)isCachedVideoFileExsit:(NSString *)videoUrl;

///**
// 播放快进到某时间点
//
// @param time 时间点
// */
//- (void)seekToTime:(NSTimeInterval)time;
/**
 开始播放
 */
- (void)startPlay;

/**
 暂停播放
 */
- (void)stopPlay;

/**
 移除监听
 */
- (void)removeObserver;

@end



@interface NSString(additions)

@end
