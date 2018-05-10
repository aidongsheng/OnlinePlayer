//
//  GCDManager.m
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "GCDManager.h"


@interface GCDManager()
@property (nonatomic,strong) dispatch_queue_t serial_queue; // 串行队列
@property (nonatomic,strong) dispatch_group_t group;        // 线程调度组
@property (nonatomic,strong) dispatch_queue_t groupConcurrentQueue; //  线程调度组队列
@property (nonatomic,strong) dispatch_queue_t concurrent_queue; //并发队列
@property (nonatomic,strong) NSLock *lock;
@end

@implementation GCDManager

+ (GCDManager *)shareInstance
{
    static GCDManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GCDManager alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)asyncExecuteOnMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
- (void)asyncExecuteOnGlobalQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
- (void)asyncExecuteOnSerialQueue:(dispatch_block_t)block
{
    dispatch_async(self.serial_queue, block);
}
- (void)asyncExecuteOnConcurrentQueue:(dispatch_block_t)block
{
    dispatch_async(self.concurrent_queue, block);
}
- (void)asyncExecuteOnGroupQueue:(dispatch_block_t)block
{
    dispatch_group_async(self.group, self.groupConcurrentQueue, block);
}
- (void)asyncExecuteOnGroupNotify:(dispatch_block_t)block
{
    dispatch_group_notify(self.group, self.groupConcurrentQueue, block);
}

- (dispatch_queue_t)serial_queue
{
    if (_serial_queue == nil) {
        _serial_queue = dispatch_queue_create("com.dongsheng.serial", DISPATCH_QUEUE_SERIAL);
    }
    return _serial_queue;
}
- (dispatch_queue_t)concurrent_queue
{
    if (_concurrent_queue == nil) {
        _concurrent_queue = dispatch_queue_create("com.dongsheng.concurrent", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrent_queue;
}
- (dispatch_group_t)group
{
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}
- (dispatch_queue_t)groupConcurrentQueue
{
    if (!_groupConcurrentQueue) {
        _groupConcurrentQueue = dispatch_queue_create("com.dongsheng.group.concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _groupConcurrentQueue;
}

- (void)executeTaskWithLock:(BlockWithLock)block
{
    block(self.lock);
}

- (NSLock *)lock
{
    if (_lock == nil) {
        _lock = [[NSLock alloc]init];
    }
    return _lock;
}
@end
