//
//  SXTaskPool.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/9/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** 队伍任务block */
typedef void (^SXTaskSchedulerBlock)(dispatch_block_t completed);

@interface SXTaskScheduler : NSObject
@property (nonatomic, copy, nullable, readonly) NSString *name;

/** 默认单例队列，该队列无法被销毁 */
+ (instancetype)share;
/** 获取指定Name的 队列 */
+ (instancetype)shareName:(NSString *_Nullable)name;
/** 根据Name 去销毁对应的队伍 */
+ (void)destory:(NSString *)name;
/**
 *  添加任务到队列中
 *  @param identifier 任务标识(标识可以为空，但为空的标识，执行查询、移除相关函数将不会有任何作用)
 *  @param task 任务block（任务执行完成后，请务必调用 block 的 completed 参数回调给任务队列，队列收到后才会去执行下一个任务）
 */
- (void)appendTaskIdentifier:(NSString *_Nullable)identifier task:(SXTaskSchedulerBlock)task;
/**
 *  通过标识去更新队列中的任务。如果任务已经执行，则无法更新
 *  @param identifier 任务标识(标识不可为空）
 *  @param task 任务block（任务执行完成后，请务必调用 block 的 completed 参数回调给任务队列，队列收到后才会去执行下一个任务）
 *  @return 更新成功返回YES，更新失败返回No(标识为空，未找到对应任务，任务已在执行)
 */
- (BOOL)updateTaskWithIdentifier:(NSString *)identifier task:(SXTaskSchedulerBlock)task;
/**
 *  判断是否包含对应标识的任务
 *  @param identifier 任务标识
 */
- (BOOL)containsIdentifier:(NSString *)identifier;
/**
 *  根据添加时的标识，移除对应的任务；正在执行中的任务，将不会被移除
 *  @param identifier 任务标识
 */
- (void)removeIdentifier:(NSString *)identifier;
/** 移除所有任务 */
- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
