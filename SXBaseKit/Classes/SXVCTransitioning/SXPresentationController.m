//
//  SXPresentationController.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXPresentationController.h"
#import "UIView+SXTransitionPrivate.h"

@interface SXPresentationController()
@property (nonatomic, strong) UIVisualEffectView *blureffectView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, assign) BOOL enableBlur;
@end
@implementation SXPresentationController

- (UIView *)overlayView {
    if (_overlayView) return _overlayView;
    if (self.overlaySource == nil) {
        self.overlaySource = [SXPresentationOverlaySource new];
    }
    if (self.overlaySource.effectStyle >= 0) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.overlaySource.effectStyle];
        _overlayView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    } else {
        _overlayView = [UIView new];
    }
    _overlayView.backgroundColor = self.overlaySource.color;
    _overlayView.alpha = self.overlaySource.alpha;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    [_overlayView addGestureRecognizer:tap];
    tap.enabled = self.overlaySource.hideWhenTouchOverlay;
    return _overlayView;
}

- (void)dismissViewController {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - override
- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    self.overlayView.frame = self.containerView.bounds;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.overlayView];
    self.containerView.sx_transitionOverlayView = self.overlayView;
    self.overlayView.alpha = 0;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.overlayView.alpha = self.overlaySource.alpha;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];

}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    if (!completed) {
        [self.overlayView removeFromSuperview];
        self.containerView.sx_transitionOverlayView = nil;
        self.overlayView.alpha = self.overlaySource.alpha;
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.overlayView.alpha = 0;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    if (completed) {
        [self.overlayView removeFromSuperview];
        self.containerView.sx_transitionOverlayView = nil;
    } else {
        self.overlayView.alpha = self.overlaySource.alpha;
    }
}

//- (CGRect)frameOfPresentedViewInContainerView {
//    CGSize preferSize = self.presentedViewController.preferredContentSize;
//    NSLog(@"%s %@",__FUNCTION__,NSStringFromCGSize(preferSize));
//    if (CGSizeEqualToSize(preferSize, CGSizeZero)) {
//        return [super frameOfPresentedViewInContainerView];
//    }
//    return CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds]) - preferSize.width)/2, (CGRectGetHeight([[UIScreen mainScreen] bounds]) - preferSize.height)/2, preferSize.width, preferSize.height);
//}

@end
