//
//  AudioHelper.m
//  OnlinePlayer
//
//  Created by wcc on 2018/5/14.
//  Copyright © 2018年 aidongsheng. All rights reserved.
//

#import "AudioHelper.h"

@interface AudioHelper()<IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end

static AudioHelper * instance = nil;

@implementation AudioHelper

+ (AudioHelper *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AudioHelper alloc]init];
    });
    return instance;
}

+ (void)readText:(NSString *)text byWho:(ReaderName)readerName
{
    
    //获取语音合成单例
    [AudioHelper shareInstance].iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    [AudioHelper shareInstance].iFlySpeechSynthesizer.delegate = [AudioHelper shareInstance];
    //设置合成参数
    //设置在线工作方式
    [[AudioHelper shareInstance].iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [[AudioHelper shareInstance].iFlySpeechSynthesizer setParameter:@"100"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    
    NSString *reader;
    if (readerName == xiaoyan) {
        reader = @"xiaoyan";
    }else if (readerName == xiaoyu){
        reader = @"xiaoyu";
    }else if (readerName == catherine){
        reader = @"catherine";
    }else if (readerName == henry){
        reader = @"henry";
    }else if (readerName == vimary){
        reader = @"vimary";
    }else if (readerName == vixy){
        reader = @"vixy";
    }else if (readerName == vixq){
        reader = @"vixq";
    }else if (readerName == vixf){
        reader = @"vixf";
    }else if (readerName == vixl){
        reader = @"vixl";
    }else if (readerName == vixr){
        reader = @"vixr";
    }else if (readerName == vixyun){
        reader = @"vixyun";
    }else if (readerName == vixk){
        reader = @"vixk";
    }else if (readerName == vixqa){
        reader = @"vixqa";
    }else if (readerName == vixyin){
        reader = @"vixyin";
    }else if (readerName == vixx){
        reader = @"vixx";
    }else if (readerName == vinn){
        reader = @"vinn";
    }else if (readerName == vils){
        reader = @"vils";
    }
    
    [[AudioHelper shareInstance].iFlySpeechSynthesizer setParameter:reader
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    
    
    
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [[AudioHelper shareInstance].iFlySpeechSynthesizer setParameter:nil
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    [[AudioHelper shareInstance].iFlySpeechSynthesizer startSpeaking:text];
    
}



//合成结束
- (void) onCompleted:(IFlySpeechError *) error {}
//合成开始
- (void) onSpeakBegin {}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {}



@end
