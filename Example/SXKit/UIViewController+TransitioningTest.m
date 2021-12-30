//
//  UIViewController+TransitioningTest.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/11/3.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "UIViewController+TransitioningTest.h"
#import "SXAlertViewController.h"
#import <SXBaseKit/UIViewController+SXTransitioning.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIViewController (TransitioningTest)

- (void)openAlert {
    SXAlertViewController *vc = [SXAlertViewController new];
    SXVCTransitioningHandle *handle = [SXVCTransitioningHandle new];
//    handle.overlaySource.color = UIColor.clearColor;
    handle.overlaySource.hideWhenTouchOverlay = NO;
    @weakify(handle);
    [handle configShowAnimation:^(UIView * _Nonnull targetView, UIView * _Nullable overlayView, CGSize containerSize, NSTimeInterval animationDuration, void (^ _Nonnull completed)(BOOL)) {
        @strongify(handle);
        targetView.frame = CGRectMake(0, containerSize.height, containerSize.width, containerSize.height);
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            targetView.frame = CGRectMake(0, 100, containerSize.width, containerSize.height);
        } completion:completed];
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] init];
        [overlayView addGestureRecognizer:pangesture];
        [targetView addGestureRecognizer:pangesture];
        pangesture.delegate = handle;
        @weakify(targetView);
        [pangesture.rac_gestureSignal subscribeNext:^(__kindof UIPanGestureRecognizer * _Nullable gesture) {
            @strongify(targetView);
            CGPoint point = [gesture translationInView:gesture.view];
            static CGPoint offsetpoint;
            static CGPoint oldCenter;
            static CGFloat offscale = 0.5;
            static BOOL hide = NO;
            switch (gesture.state) {
                case UIGestureRecognizerStateBegan:
                {
                    offsetpoint = point;
                    oldCenter = targetView.center;
                    hide = NO;
                    offscale = 0.5;
                }
                    break;
                case UIGestureRecognizerStateChanged: {
                    CGPoint p = targetView.center;
                    p = CGPointMake(p.x, p.y + (offsetpoint.y * offscale));
                    if (p.y < oldCenter.y) {
                        p.y = oldCenter.y;
                    }
                    targetView.center = p;
                    hide = offsetpoint.y > 0 ;
//                    if (hide) {
//                        offscale -= 0.01;
//                    } else {
//                        offscale += 0.01;
//                    }
//                    if (offscale > 0.5) offscale = 0.5;
//                    if (offscale < 0) offscale = 0.01;
                    offsetpoint = point;
                }
                    break;
                default:
                {
                    if (hide) {
                        UIViewController *c = (UIViewController *)targetView.nextResponder;
                        if ([c isKindOfClass:[UIViewController class]]) {
                            [c dismissViewControllerAnimated:YES completion:nil];
                        }
                    } else {
                        [UIView animateWithDuration:0.25 animations:^{
                            targetView.center = oldCenter;
                        }];
                    }
                }
                    
                    break;
            }
            [gesture setTranslation:CGPointZero inView:gesture.view];
        }];
    }];
    [handle configHideAnimation:^(UIView * _Nonnull targetView, UIView * _Nullable overlayView, CGSize containerSize, NSTimeInterval animationDuration, void (^ _Nonnull completed)(BOOL)) {
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            targetView.frame = CGRectMake(0, containerSize.height, containerSize.width, containerSize.height);
        } completion:completed];
    }];
    [handle configLayout:^(UIView * _Nonnull targetView, UIView * _Nullable overlayView, CGSize containerSize, CGFloat keyboardHeight, SXVCTransitioningLayoutType layoutType) {
        dispatch_block_t block = ^{
//            CGFloat y = (containerSize.height - w)*0.5;
//            if (containerSize.height - keyboardHeight < y + w) {
//                y = containerSize.height - keyboardHeight - w;
//            }
            targetView.frame = CGRectMake(0, 100, containerSize.width, containerSize.height);
        };
        if (layoutType == SXVCTransitioningLayoutType_MoveToSuperview) {
            block();
        } else {
            [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:block completion:nil];
        }
    }];
    [self sx_presentViewController:vc transitioning:handle completion:^{
        NSLog(@"-- present completion");
    }];
}
@end
