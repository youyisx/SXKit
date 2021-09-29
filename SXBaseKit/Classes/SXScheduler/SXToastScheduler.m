//
//  SXToast.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/9/28.
//

#import "SXToastScheduler.h"
#import <SXBaseKit/SXCustomLogger.h>
#import <SXBaseKit/SXTaskScheduler.h>
@interface SXToastScheduler()
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, strong) SXTaskScheduler *scheduler;
@property (nonatomic, copy) NSString *lastToask;
@end

@implementation SXToastScheduler

+ (instancetype)share {
    static SXToastScheduler *objc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[SXToastScheduler alloc] init];
    });
    return objc;
}
+ (NSMutableDictionary <NSString *, SXToastScheduler *>*)shareToast {
    static NSMutableDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary dictionary];
    });
    return dic;
}
+ (instancetype)shareIdentifier:(NSString *)identifier {
    if (!identifier
        || ![identifier isKindOfClass:[NSString class]]
        || identifier.length == 0) {
        return [self share];
    }
    NSMutableDictionary *share = [self shareToast];
    SXToastScheduler *objc = share[identifier];
    if (objc == nil) {
        objc = [[[self class] alloc] init];
        objc.identifier = identifier;
        share[identifier] = objc;
    }
    return objc;
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
    self.ignoreSameToast = YES;
    self.oneByOne = YES;
    self.scheduler = [[SXTaskScheduler alloc] init];
}

- (void)toast:(NSString *)toast {
    return [self toast:toast info:nil inView:nil];
}

- (void)toast:(NSString *)toast info:(NSDictionary *)info {
    return [self toast:toast info:info inView:nil];
}

- (void)toast:(NSString *)toast info:(NSDictionary *)info inView:(UIView *)view {
    __weak __typeof(self) wself = self;
    __weak __typeof(view) weakView = view;
    SXTaskSchedulerBlock block = ^(dispatch_block_t completed) {
        __strong __typeof(wself) self = wself;
        __strong __typeof(weakView) view = weakView;
        SXHUDShowConfiguration config = self.toaskShowConfiguration;
        if (!config) {
            SXCLogWarn(@"toast[%@] 无法生效，因为还未配置 [UIView sx_toaskShowConfiguration]",self.identifier);
            completed();
        } else {
            config(toast, info, view, completed);
        }
    };
    if (self.oneByOne) {
        if (self.ignoreSameToast && [self.scheduler containsIdentifier:toast]) return;
        [self.scheduler appendTaskIdentifier:toast task:block];
    } else {
        if (self.ignoreSameToast && [toast isEqualToString:self.lastToask]) return;
        self.lastToask = toast;
        block(^{
            __strong __typeof(wself) self = wself;
            self.lastToask = nil;
        });
    }
}

- (void)removeAll {
    [self.scheduler removeAll];
}

@end



