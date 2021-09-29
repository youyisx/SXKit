//
//  SXTaskPool.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/9/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SXTaskSchedulerBlock)(dispatch_block_t completed);

@interface SXTaskScheduler : NSObject
@property (nonatomic, copy, nullable, readonly) NSString *name;
+ (instancetype)share;
+ (instancetype)shareName:(NSString *_Nullable)name;
+ (void)destory:(NSString *)name;

- (void)appendTaskIdentifier:(NSString *_Nullable)identifier task:(SXTaskSchedulerBlock)task;
- (BOOL)containsIdentifier:(NSString *)identifier;
- (void)removeIdentifier:(NSString *)identifier;
- (void)removeAll;
@end

NS_ASSUME_NONNULL_END
