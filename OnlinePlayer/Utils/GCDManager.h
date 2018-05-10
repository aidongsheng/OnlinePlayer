//
//  GCDManager.h
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BlockWithLock)(NSLock *lock);


@interface GCDManager : NSObject

+ (GCDManager *)shareInstance;

/**
 异步在主线程执行代码

 @param block 代码块
 */
- (void)asyncExecuteOnMainQueue:(dispatch_block_t)block;

/**
 异步在全局线程执行代码
 
 @param block 代码块
 */
- (void)asyncExecuteOnGlobalQueue:(dispatch_block_t)block;
/**
 异步在串行队列执行代码
 
 @param block 代码块
 */
- (void)asyncExecuteOnSerialQueue:(dispatch_block_t)block;
/**
 异步在并发线程执行代码
 
 @param block 代码块
 */
- (void)asyncExecuteOnConcurrentQueue:(dispatch_block_t)block;
/**
 异步在向线程调度组添加执行代码
 
 @param block 代码块
 */
- (void)asyncExecuteOnGroupQueue:(dispatch_block_t)block;
/**
 所有线程调度组任务执行完成之后，调用此方法
 
 @param block 代码块
 */
- (void)asyncExecuteOnGroupNotify:(dispatch_block_t)block;

- (void)executeTaskWithLock:(BlockWithLock)block;

@end
