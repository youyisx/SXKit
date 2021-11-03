//
//  UIViewController+SXTransitioning.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/11/1.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "UIViewController+SXTransitioning.h"
#import <objc/runtime.h>


static void* k_sx_transitioningDelegate = &k_sx_transitioningDelegate;
@implementation UIViewController (SXTransitioning)
@dynamic sx_transitioningDelegate;
- (void)setSx_transitioningDelegate:(id<UIViewControllerTransitioningDelegate>)sx_transitioningDelegate {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = sx_transitioningDelegate;
    objc_setAssociatedObject(self, k_sx_transitioningDelegate, sx_transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIViewControllerTransitioningDelegate>)sx_transitioningDelegate {
    return objc_getAssociatedObject(self, k_sx_transitioningDelegate);
}

- (void)sx_presentViewController:(UIViewController *)controller
                   transitioning:(SXVCTransitioningHandle *)transitioning
                      completion:(dispatch_block_t)completion{
    if ([transitioning isKindOfClass:[SXVCTransitioningHandle class]]) {
        controller.sx_transitioningDelegate = transitioning;
    }
    [self presentViewController:controller animated:YES completion:completion];
}

@end
