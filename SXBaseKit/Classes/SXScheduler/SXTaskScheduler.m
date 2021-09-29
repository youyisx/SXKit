//
//  SXTaskPool.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/9/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXTaskScheduler.h"
#import <SXBaseKit/SXCustomLogger.h>

@interface SXTaskSchedulerItem : NSObject
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy) SXTaskSchedulerBlock block;
@end
@implementation SXTaskSchedulerItem

+ (instancetype)identifier:(NSString *_Nullable)identifier
                     block:(SXTaskSchedulerBlock)block {
    SXTaskSchedulerItem *item = [[SXTaskSchedulerItem alloc] init];
    item.identifier = identifier;
    item.block = block;
    return item;
}
- (void)active:(dispatch_block_t)completed {
    if (self.block) {
        self.block(completed);
    } else {
        !completed?:completed();
    }
}

@end

@interface SXTaskScheduler()
@property (nonatomic, copy, nullable, readwrite) NSString *name;
@property (nonatomic, strong, class, readonly) NSMutableDictionary <NSString *, SXTaskScheduler *>*pools;

@property (nonatomic, strong) NSMutableArray <SXTaskSchedulerItem *>*schedulerItems;

@property (nonatomic, assign) BOOL isDispatch;

@end
@implementation SXTaskScheduler

+ (NSMutableDictionary<NSString *,SXTaskScheduler *> *)pools {
    static NSMutableDictionary *pools_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pools_ = [NSMutableDictionary dictionary];
    });
    return pools_;
}

+ (instancetype)share {
    static SXTaskScheduler *pool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[SXTaskScheduler alloc] init];
    });
    return pool;
}

+ (instancetype)shareName:(NSString *)name {
    if (!name || ![name isKindOfClass:[NSString class]] || name.length == 0) return [self share];
    SXTaskScheduler *pool_ = [self pools][name];
    if (!pool_) {
        pool_ = [[SXTaskScheduler alloc] init];
        pool_.name = name;
        [self pools][name] = pool_;
    }
    return pool_;
}

+ (void)destory:(NSString *)name {
    [self pools][name] = nil;
}
#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.isDispatch = NO;
    self.schedulerItems = [NSMutableArray array];
}

- (void)appendTaskIdentifier:(NSString *)identifier task:(SXTaskSchedulerBlock)task {
    if (!task) {
        SXCLogWarn(@"无法添加空任务...");
        return;
    }
    SXTaskSchedulerItem *item = [SXTaskSchedulerItem identifier:identifier block:task];
    [self.schedulerItems addObject:item];
    [self _dispatch];
}

- (void)_dispatch {
    if (self.isDispatch) return;
    if (self.schedulerItems.count == 0) return;
    SXTaskSchedulerItem *item = self.schedulerItems[0];
    self.isDispatch = YES;
    __weak __typeof(self) wself = self;
    [item active:^{
        __strong __typeof(wself) self = wself;
        [self.schedulerItems removeObjectAtIndex:0];
        self.isDispatch = NO;
        [self _dispatch];
    }];
}

- (BOOL)containsIdentifier:(NSString *)identifier {
    if (![identifier isKindOfClass:[NSString class]] || identifier.length == 0) return NO;
    for (SXTaskSchedulerItem *item in self.schedulerItems) {
        if ([item.identifier isEqualToString:identifier]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeIdentifier:(NSString *)identifier {
    if (![identifier isKindOfClass:[NSString class]] || identifier.length == 0) return;
    /// 第0个已经开始执行任务了，所以就从第1个开始查找移除
    for (int i = 1; i < self.schedulerItems.count; i++) {
        SXTaskSchedulerItem *item = self.schedulerItems[i];
        if ([item.identifier isEqualToString:identifier]) {
            [self.schedulerItems removeObjectAtIndex:i];
            i--;
        }
    }
}

- (void)removeAll {
    [self.schedulerItems removeAllObjects];
}
@end

