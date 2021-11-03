//
//  UIView+SXTransitionPrivate.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/11/3.
//

#import "UIView+SXTransitionPrivate.h"
#import <objc/runtime.h>

static void *k_sx_transitionOverlayView = &k_sx_transitionOverlayView;
@implementation UIView (SXTransitionPrivate)
@dynamic sx_transitionOverlayView;

- (void)setSx_transitionOverlayView:(UIView *)sx_transitionOverlayView {
    objc_setAssociatedObject(self, k_sx_transitionOverlayView, sx_transitionOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sx_transitionOverlayView {
    return objc_getAssociatedObject(self, k_sx_transitionOverlayView);
}


@end
