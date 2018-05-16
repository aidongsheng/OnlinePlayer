//
//  FPSTool.m
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "FPSTool.h"

@interface FPSTool()
@property (nonatomic,strong) UILabel *displayLinkInfoLabel;
@property (nonatomic,assign) long long count;
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,assign) CFTimeInterval timestamp;
@end

@implementation FPSTool
+ (FPSTool *)shareInstance
{
    static FPSTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FPSTool alloc]init];
    });
    return instance;
}
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            _count = 0;
            _timestamp = 0;
        }];
    }
    return self;
}
- (void)showFPSInfomation
{
    
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaySelector:)];
    }
    [_link setPaused:NO];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)hideFPSInfomation
{
    [_link setPaused:YES];
    [_link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link = nil;
    _count = 0;
    _timestamp = 0;
}
- (void)displaySelector:(CADisplayLink *)link
{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self.displayLinkInfoLabel]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.displayLinkInfoLabel];
    }
    _count++;
    if (_timestamp == 0) {
        _timestamp = _link.timestamp;
    }
    double dvalue = _link.timestamp - _timestamp;
    NSLog(@"count = %lli,dvalue = %f,fps=%.1f",_count,dvalue,_count/dvalue);
    
    _displayLinkInfoLabel.text = [NSString stringWithFormat:@"屏幕刷新频率:%.1f fps \n时间:%.2f s",_count/dvalue,dvalue];
}
- (UILabel *)displayLinkInfoLabel
{
    if (_displayLinkInfoLabel == nil) {
        _displayLinkInfoLabel = [[UILabel alloc]init];
        _displayLinkInfoLabel.numberOfLines = 0;
        _displayLinkInfoLabel.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 100);
        _displayLinkInfoLabel.textColor = [UIColor greenColor];
        _displayLinkInfoLabel.textAlignment = NSTextAlignmentLeft;
        _displayLinkInfoLabel.font = [UIFont HeitiSCWithFontSize:20];
    }
    return _displayLinkInfoLabel;
}

@end
