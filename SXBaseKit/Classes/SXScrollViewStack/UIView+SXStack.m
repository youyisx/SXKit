//
//  UIView+SXStack.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/8/4.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "UIView+SXStack.h"
#import <objc/runtime.h>
#import "UIScrollView+SXStack.h"

#define k_sx_stackEdge "sx_stackEdge"
#define k_sx_stackHeight "sx_stackHeight"

#define k_sx_adjustUpdate "sx_stack_adjustUpdate"
@implementation UIView (SXStack)
@dynamic sx_stackEdge,sx_stackHeight;

- (void)setSx_stackEdge:(UIEdgeInsets)sx_stackEdge {
    if (UIEdgeInsetsEqualToEdgeInsets(sx_stackEdge, self.sx_stackEdge)) return;
    [self willChangeValueForKey:@k_sx_stackEdge];
    objc_setAssociatedObject(self, k_sx_stackEdge, [NSValue valueWithUIEdgeInsets:sx_stackEdge], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@k_sx_stackEdge];
    [self _sx_updateArrangeSubviews];
}

- (UIEdgeInsets)sx_stackEdge {
    return [objc_getAssociatedObject(self, k_sx_stackEdge) UIEdgeInsetsValue];
}

- (void)setSx_stackHeight:(NSInteger)sx_stackHeight {
    if (self.sx_stackHeight == sx_stackHeight) return;
    [self willChangeValueForKey:@k_sx_stackHeight];
    objc_setAssociatedObject(self, k_sx_stackHeight, @(sx_stackHeight), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@k_sx_stackHeight];
    [self _sx_updateArrangeSubviews];
}

- (NSInteger)sx_stackHeight {
    return [objc_getAssociatedObject(self, k_sx_stackHeight) integerValue];
}


- (void)_sx_updateArrangeSubviews {
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (![scrollView isKindOfClass:[UIScrollView class]]) return;
    BOOL adjustUpdate = [objc_getAssociatedObject(self, k_sx_adjustUpdate) boolValue];
    if (adjustUpdate) return;
    objc_setAssociatedObject(self, k_sx_adjustUpdate, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView layoutArrangeSubviewsFromView:self];
        objc_setAssociatedObject(self, k_sx_adjustUpdate, @(NO), OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

@end

