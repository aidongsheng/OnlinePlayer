//
//  OnlineVideoPlayer.m
//  wochacha
//
//  Created by wcc on 2018/4/24.
//  Copyright © 2018年 wochacha. All rights reserved.
//

#import "OnlineVideoPlayer.h"
#import "NSString+ADS.h"
#import <AVFoundation/AVFoundation.h>

@interface OnlineVideoPlayer()
@property (nonatomic, strong) UILabel *labelNetworkStatus;
@property (nonatomic, strong) UIButton *buttonClosePlayer;
@property (nonatomic ,strong) AVPlayer *player;     //  播放器
@property (nonatomic, strong) AVPlayerItem *playItem;   //  播放器资源对象
@property (nonatomic, strong) id timeObserve;           //  用于监听播放时间进度
@end
@implementation OnlineVideoPlayer


+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoUrl:(NSString *)videoUrl delegate:(id<OnlineVideoPlayerDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        [self playerVideoWithUrl:videoUrl];
        [self addSubview:self.buttonClosePlayer];
        [self addSubview:self.labelNetworkStatus];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)startPlay
{
    [self.player play];
    self.player.rate = 1;
}
- (void)stopPlay
{
    self.player.rate = 0;
}

- (void)playerVideoWithUrl:(NSString *)videoUrl
{
    ((AVPlayerLayer *)(self.layer)).videoGravity = AVLayerVideoGravityResizeAspect;
    
    if ([self isWiFi]) {
        if ([self isCachedVideoFileExsit:videoUrl]) {
            //wifi下有缓存，播放
            [self playCachedVideoWithUrl:videoUrl];
        }else{
            //wifi下没有缓存，在线播放
            [self playOnlineVideoWithUrl:videoUrl];
            //下载视频
            [[GCDManager shareInstance] asyncExecuteOnGlobalQueue:^{
                [self removeOldFileByVideoURL:videoUrl];
                [self downloadVideoWithVideoUrl:videoUrl];
            }];
        }
    }else{
        if ([self isCachedVideoFileExsit:videoUrl]) {
            NSLog(@"非wifi环境，但是有对应 url 的缓存，则播放缓存文件");
            [self playCachedVideoWithUrl:videoUrl];
        }else{
            NSLog(@"既无缓存，也是非WiFi环境，则直接进入主页");
            if (self.delegate && [self.delegate respondsToSelector:@selector(closeStartADController)]) {
                [self.delegate closeStartADController];
            }
        }
    }
    [self addObserver];
}


- (void)removeOldFileByVideoURL:(NSString *)videoURL
{
    //判断当前的路径是否有，没有的话，判断改文件夹下其他的文件删除
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dirPath = [dirPath stringByAppendingPathComponent:@"video"];
    NSString *strURLMD5 = [videoURL ads_MD5String];
    NSString *filePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",strURLMD5]];
    if (![fileMgr fileExistsAtPath:filePath]) {
        NSError *error;
        NSArray * files = [fileMgr contentsOfDirectoryAtPath:dirPath error:&error];
        NSEnumerator *eFiles = [files objectEnumerator];
        NSString *strFileName;
        while (strFileName = [eFiles nextObject]) {
            NSError *errRemove = nil;
            NSString *strFileToBeRemovedPath = [dirPath stringByAppendingPathComponent:strFileName];
            [fileMgr removeItemAtPath:strFileToBeRemovedPath error:&errRemove];
            if (errRemove) {
                NSLog(@"删除文件失败");
            }else{
                NSLog(@"删除文件成功");
            }
        }
    }
}

/**
 添加监听对象
 */
- (void)addObserver
{
    if (_playItem != nil && self.player != nil) {
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            _currentTime = ceil(CMTimeGetSeconds(time));
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 移除监听对象
 */
- (void)removeObserver
{
    if (_playItem != nil && self.player != nil) {
        if (_timeObserve) {
            [self.player removeTimeObserver:_timeObserve];
            _timeObserve = nil;
        }
        [self.player removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
}
/**
 根据通知，播放结束时自动调用
 */
- (void)didPlayToEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStopVideoPlayer)]) {
        [self.delegate didStopVideoPlayer];
    }
}
- (void)didFailedToPlayToEnd {
    NSLog(@"didFailedToPlayToEnd");
}
- (UILabel *)labelNetworkStatus
{
    if (_labelNetworkStatus == nil) {
        _labelNetworkStatus = [[UILabel alloc]init];
        _labelNetworkStatus.textColor = [UIColor whiteColor];
        _labelNetworkStatus.backgroundColor = [UIColor grayColor];
        _labelNetworkStatus.layer.cornerRadius = 10;
        _labelNetworkStatus.clipsToBounds = YES;
        _labelNetworkStatus.alpha = 0.5;
        _labelNetworkStatus.text = @"已WiFi预加载";
        _labelNetworkStatus.font = [UIFont HeitiSCWithFontSize:12];
        _labelNetworkStatus.textAlignment = NSTextAlignmentCenter;
        _labelNetworkStatus.hidden = YES;
    }
    return _labelNetworkStatus;
}
- (UIButton *)buttonClosePlayer
{
    if (_buttonClosePlayer == nil) {
        _buttonClosePlayer = [[UIButton alloc]init];
        _buttonClosePlayer.titleLabel.textColor = [UIColor whiteColor];
        _buttonClosePlayer.layer.cornerRadius = 3.3;
        _buttonClosePlayer.backgroundColor = [UIColor grayColor];
        _buttonClosePlayer.alpha = 0.5;
        [_buttonClosePlayer setTitle:@"跳过" forState:UIControlStateNormal];
        if (iPhone4s) {
            _buttonClosePlayer.titleLabel.font = [UIFont HeitiSCWithFontSize:12];
        }else{
            _buttonClosePlayer.titleLabel.font = [UIFont HeitiSCWithFontSize:16];
        }
        [_buttonClosePlayer addTarget:self action:@selector(didInterruptADPlaying) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonClosePlayer;
}

/**
 点击跳过按钮中断播放的代理
 */
- (void)didInterruptADPlaying
{
    NSLog(@"中断播放代理");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didInterruptADPlaying:)]) {
        [self.delegate didInterruptADPlaying:_currentTime];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerCloseButtonBeClicked)]) {
        [self.delegate playerCloseButtonBeClicked];
    }
}
/**
 在线播放视频
 
 @param videoUrl 视频链接
 */
- (void)playOnlineVideoWithUrl:(NSString *)videoUrl
{
    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    AVURLAsset *URLAsset = [AVURLAsset assetWithURL:videoURL];
    _playItem = [AVPlayerItem playerItemWithAsset:URLAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playItem];
    [self.player play];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartVideoPlayer)]) {
        [self.delegate didStartVideoPlayer];
    }
}

/**
 播放本地视频
 
 @param videoUrl 视频链接
 */
- (void)playCachedVideoWithUrl:(NSString *)videoUrl
{
    if (![self isWiFi]) {
        self.labelNetworkStatus.hidden = NO;
    }
    NSString *strVideoUrl = [self cachedVideoURL:videoUrl];
    NSURL *urlVideoUrl = [NSURL fileURLWithPath:strVideoUrl];
    _playItem = [AVPlayerItem playerItemWithURL:urlVideoUrl];
    self.player = [AVPlayer playerWithPlayerItem:_playItem];
    [self.player play];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartVideoPlayer)]) {
        [self.delegate didStartVideoPlayer];
    }
    
}
/**
 判断是否是WiFi环境
 
 @return 是否是WiFi的标识
 */
- (BOOL)isWiFi
{
    if ([YYReachability reachability].status == YYReachabilityStatusWiFi) {
        return YES;
    }else{
        return NO;
    }
}

/**
 下载视频
 */
- (void)downloadVideoWithVideoUrl:(NSString *)videlUrl
{
    NSURL *urlVideoUrl = [NSURL URLWithString:videlUrl];
    NSMutableURLRequest *reqDownload = [NSMutableURLRequest requestWithURL:urlVideoUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadtask = [session downloadTaskWithRequest:reqDownload];
    [downloadtask resume];
}
/**
 根据视频链接，返回本地文件路径
 
 @param videoUrl 视频链接
 @return 本地文件路径
 */
- (NSString *)cachedVideoURL:(NSString *)videoUrl
{
    NSString *strFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strFilePath = [strFilePath stringByAppendingPathComponent:@"video"];
    NSString *strMD5VideoUrl = [videoUrl ads_MD5String];
    strFilePath = [strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",strMD5VideoUrl]];
    return strFilePath;
}

/**
 判断对应 videourl 的本地视频文件是否存在
 
 @param videoUrl 视频链接地址
 @return 是否存在的标识
 */
- (BOOL)isCachedVideoFileExsit:(NSString *)videoUrl
{
    NSString *strVideoFilePath = [self cachedVideoURL:videoUrl];
    return [[NSFileManager defaultManager] fileExistsAtPath:strVideoFilePath];
}

//  下载完成后调用此方法，在此处执行创建文件夹以及保存缓存文件至目的文件
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *strDestPath = [self createVideoFolder];
    [self moveTempFile:location downloadTask:downloadTask toDestFolder:strDestPath];
}

/**
 创建视频文件夹
 */
- (NSString *)createVideoFolder
{
    NSString *strDestPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strDestPath = [strDestPath stringByAppendingPathComponent:@"video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bIsDir;
    //  创建文件夹路径
    if (![fileManager fileExistsAtPath:strDestPath isDirectory:&bIsDir]) {
        NSError * createFolderError = nil;
        [fileManager createDirectoryAtPath:strDestPath withIntermediateDirectories:YES attributes:nil error:&createFolderError];
        if (createFolderError) {
            NSLog(@"创建文件夹 %@ 失败",strDestPath);
        }else{
            NSLog(@"创建文件夹 %@ 成功",strDestPath);
        }
    }else{
        NSLog(@"文件夹 %@ 已存在，请勿重复创建",strDestPath);
    }
    return strDestPath;
}
//  创建文件路径并将已下载临时文件移动至自定义文件夹中
- (void)moveTempFile:(NSURL *)location downloadTask:(NSURLSessionDownloadTask *)downloadTask toDestFolder:(NSString *)destPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strMD5VideoURL = [NSString stringWithFormat:@"%@",downloadTask.originalRequest.URL];
    strMD5VideoURL = [strMD5VideoURL ads_MD5String];
    NSString *strFilePath = [destPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",strMD5VideoURL]];
    if (![fileManager fileExistsAtPath:strFilePath]) {
        NSLog(@"创建文件 %@ 成功",strFilePath);
        NSError *moveFileError = nil;
        [fileManager moveItemAtPath:location.path toPath:strFilePath error:&moveFileError];
        if (moveFileError) {
            NSLog(@"将临时文件 %@ 移动到文件 %@ 失败 %@",location.path,strFilePath,moveFileError);
        }else{
            NSLog(@"将临时文件 %@ 移动到文件 %@ 成功",location.path,strFilePath);
        }
    }else{
        NSLog(@"文件 %@ 已存在，请勿重复下载",strFilePath);
    }
}

//  实现此处可获取当前下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"写入比特:%10lli,全部已写入比特:%10lli,全部待写入比特%10lli,已下载: %3.1f",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite,(float)totalBytesWritten/totalBytesExpectedToWrite);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(iPhone4s || iPhone5 || iPhone6 || SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.labelNetworkStatus.frame = CGRectMake(self.width/2-60, STATUS_HEIGHT+5+5, 120, 20);
        self.buttonClosePlayer.frame = CGRectMake(self.width - 60, STATUS_HEIGHT+5, 50, 30);
    }else{
        self.labelNetworkStatus.frame = CGRectMake(self.width/2-80, STATUS_HEIGHT+5+5, 160, 20);
        self.buttonClosePlayer.frame = CGRectMake(self.width - 70, STATUS_HEIGHT+5, 60, 30);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedVideoPlayer)]) {
        [self.delegate didTapedVideoPlayer];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //监控网络加载情况属性
    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"loadedTimeRanges"]) {
        CMTime timeRange = self.playItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(timeRange);
        _totalDuration = totalDuration;
        _totalDuration = ceil(_totalDuration);
    }
    //缓存可以播放的时候调用
    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        [self.player play];
    }
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    if ([object isEqual:self.player] && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self.player play];
        }else if (self.player.status == AVPlayerStatusFailed) {
        }else if (self.player.status == AVPlayerStatusUnknown) {
        }
    }
}

@end

