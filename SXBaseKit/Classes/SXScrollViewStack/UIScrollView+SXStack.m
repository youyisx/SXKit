//
//  UIScrollView+SXStack.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/8/4.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "UIScrollView+SXStack.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>


#define k_sxstack_arrangedSubviews "arrangedSubviews"
#define k_sxstack_animationUpdate "animationDuration"

#define k_observers_layoutSubviews "k_observers_layoutSubviews"
#define k_sxstack_arrangedWidth "k_sxstack_arrangedWidth"
@implementation UIScrollView (SXStack)

@dynamic arrangedSubviews,animationDuration;

- (NSInteger)arrangedWidth {
    return ceil(self.bounds.size.width);
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    [self willChangeValueForKey:@k_sxstack_animationUpdate];
    objc_setAssociatedObject(self, k_sxstack_animationUpdate, @(animationDuration), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@k_sxstack_animationUpdate];
}

- (NSTimeInterval)animationDuration {
    return [objc_getAssociatedObject(self, k_sxstack_animationUpdate) doubleValue];
}

- (void)setArrangedSubviews:(NSArray<UIView *> *)arrangedSubviews {
    NSArray <UIView *>*last = [self arrangedSubviews];
    [last enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self willChangeValueForKey:@k_sxstack_arrangedSubviews];
    objc_setAssociatedObject(self, k_sxstack_arrangedSubviews, [arrangedSubviews mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@k_sxstack_arrangedSubviews];
    
    
    [self layoutArrangeSubviews];
    
    if ([objc_getAssociatedObject(self, k_observers_layoutSubviews) boolValue]) return;
    /// 启动对layoutSubviews的监听
    @weakify(self)
    [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if ([objc_getAssociatedObject(self, k_sxstack_arrangedWidth) integerValue] == [self arrangedWidth]) return;
        [self layoutArrangeSubviews];
    }];
    objc_setAssociatedObject(self, k_observers_layoutSubviews, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<UIView *> *)arrangedSubviews {
    return objc_getAssociatedObject(self, k_sxstack_arrangedSubviews);
}

- (NSMutableArray<UIView *> *)mutableArrangedSubviews {
    return ((NSMutableArray *)[self arrangedSubviews]);
}

- (void)addArrangedSubview:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) return;
    NSMutableArray *result = [self mutableArrangedSubviews];
    if (result == nil) {
        self.arrangedSubviews = @[view];
    } else {
        [result addObject:view];
        [self layoutArrangeSubviewsFromIndex:result.count - 1];
    }
}

- (void)removeArrangedSubview:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) return;
    NSMutableArray *result = [self mutableArrangedSubviews];
    if (![result containsObject:view]) return;
    [view removeFromSuperview];
    NSInteger stackIndex = [result indexOfObject:view];
    [result removeObjectAtIndex:stackIndex];
    [self layoutArrangeSubviewsFromIndex:stackIndex];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if (![view isKindOfClass:[UIView class]]) return;
    NSInteger targetIdx = stackIndex;
    NSMutableArray *result = [self mutableArrangedSubviews];
    NSInteger oldIdx = -1;
    if ([result containsObject:view]) {
        oldIdx = [result indexOfObject:view];
        [result removeObjectAtIndex:oldIdx];
    }
    if (targetIdx < result.count) {
        [result insertObject:view atIndex:targetIdx];
    } else {
        targetIdx = result.count;
        [result addObject:view];
    }
    [self layoutArrangeSubviewsFromIndex:oldIdx >= 0 ? MIN(oldIdx, targetIdx) : targetIdx];
}

/// 如果不存在，则返回-1
- (NSInteger)indexOfArrangeView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) return -1;
    NSArray <UIView *> *list = self.arrangedSubviews;
    if ([list containsObject:view]) return [list indexOfObject:view];
    return -1;
}

#pragma mark ---
- (void)layoutArrangeSubviews {
    [self layoutArrangeSubviewsFromIndex:0];
}

- (void)layoutArrangeSubviewsFromIndex:(NSInteger)stackIndex {
    if ([self arrangedWidth] <= 0) return;
    NSArray <UIView *> *list = self.arrangedSubviews;
    NSInteger stIdx = stackIndex;
    if (stIdx <= 0 || stIdx >= list.count) stIdx = 0;
    if (stIdx >= list.count) return;
    
    NSInteger arrangedWidth_ = [self arrangedWidth];
    UIView *lastView = stIdx == 0 ? nil : list[stIdx - 1];
    CGFloat totalH = CGRectGetMaxY(lastView.frame) + lastView.sx_stackEdge.bottom;
    NSTimeInterval duration = self.animationDuration;
    if (duration < 0) duration = 0;
    for (NSInteger i = stIdx; i < list.count; i++) {
        UIView *view = list[i];
        UIEdgeInsets edge = view.sx_stackEdge;
        NSInteger height = view.sx_stackHeight;
        CGRect frame = CGRectMake(edge.left, edge.top + totalH, arrangedWidth_ - edge.left - edge.right, height);
        if (view.superview != self) {
            [self addSubview:view];
            if (i > 0) {
                CGFloat lastBottomY = CGRectGetMaxY(list[i-1].frame);
                view.frame = CGRectOffset(frame, 0, lastBottomY - frame.origin.y);
            } else {
                view.frame = CGRectOffset(frame, 0, -frame.size.height);
            }
        }
        if (duration == 0) {
            view.frame = frame;
        } else {
            [UIView animateWithDuration:duration animations:^{
                view.frame = frame;
            }];
        }
        totalH = CGRectGetMaxY(frame) + edge.bottom;
    }
    self.contentSize = CGSizeMake(0, totalH);
    /// 下标为0，则是全部调整frame, 需要记录一下，避免layoutsubviews 反复触发
    if (stIdx == 0) objc_setAssociatedObject(self, k_sxstack_arrangedWidth, @(arrangedWidth_), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (void)layoutArrangeSubviewsFromView:(UIView *)view {
    if (view.superview != self) return;
    NSArray <UIView *> *list = self.arrangedSubviews;
    if (![list containsObject:view]) return;
    NSInteger idx = [list indexOfObject:view];
    [self layoutArrangeSubviewsFromIndex:idx];
}
@end

