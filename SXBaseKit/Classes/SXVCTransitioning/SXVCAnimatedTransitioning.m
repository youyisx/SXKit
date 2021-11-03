//
//  SXVCAnimatedTransitioning.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/11/1.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXVCAnimatedTransitioning.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIView+SXTransitionPrivate.h"
@interface SXVCAnimatedTransitioning()
@property (nonatomic, assign, readwrite) SXVCAnimatedTransitionType type;
@end
@implementation SXVCAnimatedTransitioning

+ (instancetype)animatedTransitioning:(SXVCAnimatedTransitionType)type {
    SXVCAnimatedTransitioning *animated = [SXVCAnimatedTransitioning new];
    animated.type = type;
    return animated;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.45;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (transitionContext.isAnimated == NO) {
        duration = 0;
    }
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * containerView = [transitionContext containerView];
    if (self.type == SXVCAnimatedTransitioning_Show) {
        [containerView addSubview:toView];
        if (self.animationBlock) {
            self.animationBlock(toView, containerView.sx_transitionOverlayView, containerView.bounds.size, duration, ^(BOOL sucess) {
                BOOL transitionWasCancelled = [transitionContext transitionWasCancelled];
                if (transitionWasCancelled) {
                    [toView removeFromSuperview];
                }
                [transitionContext completeTransition:!transitionWasCancelled];
                if (fromView.superview == nil) {
                    [containerView insertSubview:fromView belowSubview:toView];
                }
            });
        } else {
            toView.frame = containerView.bounds;
            [transitionContext completeTransition:YES];
        }
        [self addObserverWithContainerView:containerView
                                  showView:toView
                               layoutBlock:self.layoutBlock];
        
    } else {
        /// 如果是pop动画，toView的superview是为空的，所以要在这里重新添加一下
        if (toView.superview == nil) {
            [containerView addSubview:toView];
            if (fromView.superview == containerView) {
                [containerView bringSubviewToFront:fromView];
            }
        }
        if (self.animationBlock) {
            self.animationBlock(fromView, containerView.sx_transitionOverlayView, containerView.bounds.size, duration, ^(BOOL sucess) {
                BOOL transitionWasCancelled = [transitionContext transitionWasCancelled];
                [transitionContext completeTransition:!transitionWasCancelled];
            });
        } else {
            [transitionContext completeTransition:YES];
        }
        
    }
}


- (void)addObserverWithContainerView:(UIView *)containerView
                            showView:(UIView *)showView
                         layoutBlock:(SXVCTransitioningLayout)layoutBlock{
    if (!containerView || !showView || !layoutBlock) return;
    __block CGSize containerSize = containerView.bounds.size;
    __block BOOL didRemoveToView = NO;
    __block CGFloat keyboardHeight = 0;
    @weakify(containerView, showView);
    [[containerView rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(containerView, showView);
        if (!containerView || !showView) return;
        if (showView.superview != containerView) {
            didRemoveToView = YES;
            return;
        }
        CGSize size = containerView.bounds.size;
        if (didRemoveToView == NO && CGSizeEqualToSize(containerSize, size)) return;
        containerSize = size;
        SXVCTransitioningLayoutType layoutType = SXVCTransitioningLayoutType_SizeChange;
        if (didRemoveToView) layoutType = SXVCTransitioningLayoutType_MoveToSuperview;
        didRemoveToView = NO;
        layoutBlock(showView, containerView.sx_transitionOverlayView, containerSize, keyboardHeight, layoutType);
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification
                                                            object:nil]
      takeUntil:containerView.rac_willDeallocSignal]
     subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(containerView, showView);
        keyboardHeight = 0;
        if (!containerView || !showView) return;
        if (showView.superview != containerView) return;
        layoutBlock(showView, containerView.sx_transitionOverlayView, containerSize, keyboardHeight, SXVCTransitioningLayoutType_KeyboardChange);
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification
                                                            object:nil]
      takeUntil:containerView.rac_willDeallocSignal]
     subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(containerView, showView);
        CGFloat height = [x.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        if (keyboardHeight == height) return;
        keyboardHeight = height;
        if (!containerView || !showView) return;
        if (showView.superview != containerView) return;
        layoutBlock(showView, containerView.sx_transitionOverlayView, containerSize, keyboardHeight, SXVCTransitioningLayoutType_KeyboardChange);
    }];
    
}


@end
