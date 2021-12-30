//
//  SXVCTransitioningHandle.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXVCTransitioningHandle.h"
#import "SXPresentationController.h"
@interface SXVCTransitioningHandle()
@property (nonatomic, copy) SXVCTransitioningAnimation showAnimation;
@property (nonatomic, copy) SXVCTransitioningAnimation hideAnimation;
@property (nonatomic, copy) SXVCTransitioningLayout    layoutBlock;
//@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end
@implementation SXVCTransitioningHandle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
//    self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    self.overlaySource = [SXPresentationOverlaySource new];
}

- (void)configHideAnimation:(SXVCTransitioningAnimation)animation {
    self.hideAnimation = animation;
}

- (void)configShowAnimation:(SXVCTransitioningAnimation)animation {
    self.showAnimation = animation;
}

- (void)configLayout:(SXVCTransitioningLayout)layout {
    self.layoutBlock = layout;
}
#pragma mark - UINavigationControllerDelegate

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    SXVCAnimatedTransitioning *transitioning = animationController;
//    if ([transitioning isKindOfClass:[SXVCAnimatedTransitioning class]] && transitioning.type == SXVCAnimatedTransitioning_Hidden) {
//        return self.interactiveTransition;
//    }
//    return nil;
//}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush && self.showAnimation) {
        SXVCAnimatedTransitioning *animationed = [SXVCAnimatedTransitioning animatedTransitioning:SXVCAnimatedTransitioning_Show];
        animationed.animationBlock = self.showAnimation;
        return animationed;
    } else if (operation == UINavigationControllerOperationPop && self.hideAnimation) {
        SXVCAnimatedTransitioning *animationed = [SXVCAnimatedTransitioning animatedTransitioning:SXVCAnimatedTransitioning_Hidden];
        animationed.animationBlock = self.hideAnimation;
        return animationed;
    }
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    if (self.showAnimation == nil) return nil;
    SXVCAnimatedTransitioning *animationed = [SXVCAnimatedTransitioning animatedTransitioning:SXVCAnimatedTransitioning_Show];
    animationed.animationBlock = self.showAnimation;
    animationed.layoutBlock = self.layoutBlock;
    return animationed;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.hideAnimation == nil) return nil;
    SXVCAnimatedTransitioning *animationed = [SXVCAnimatedTransitioning animatedTransitioning:SXVCAnimatedTransitioning_Hidden];
    animationed.animationBlock = self.hideAnimation;
    return animationed;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    SXPresentationController *controller = [[SXPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    controller.overlaySource = self.overlaySource;
    return controller;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    /// 允许同时识别多手势
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    return YES;
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//   
//    return YES;
//}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}
@end
