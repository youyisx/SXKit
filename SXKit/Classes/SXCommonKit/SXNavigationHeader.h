//
//  SXNavigationHeader.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#ifndef SXNavigationHeader_h
#define SXNavigationHeader_h

#import <UIKit/UIKit.h>

NS_INLINE id<UIApplicationDelegate> SXAppDelegate() {
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate;
}

NS_INLINE UIWindow *SXRootWindow() {
    UIWindow *window = nil;
    if ([SXAppDelegate() respondsToSelector:@selector(window)]) window = [SXAppDelegate() window];
    if (window == nil) window = [[UIApplication sharedApplication].windows firstObject];
    return window;
}

NS_INLINE UIViewController* SXRootVC() {
    return SXRootWindow().rootViewController;
}
/// 找到当前controller
NS_INLINE UIViewController* SXValidVC() {
    UIViewController *rootvc = SXRootVC();
    while (rootvc.presentedViewController != nil) rootvc = rootvc.presentedViewController;
    while (true) {
        if ([rootvc isKindOfClass:[UITabBarController class]]) {
            rootvc = ((UITabBarController *)rootvc).selectedViewController;
        } else if ([rootvc isKindOfClass:[UINavigationController class]]) {
            rootvc = [((UINavigationController *)rootvc).viewControllers lastObject];
        } else {
            break;
        }
    }
   if ([rootvc isKindOfClass:[UIAlertController class]]) rootvc = rootvc.presentingViewController;
    return rootvc;
}
/// 通过指定控制器去找查其堆栈内的navigationcontroller
NS_INLINE UINavigationController* _SXValidNC(UIViewController *vc) {
    UIViewController *rootvc =vc;
    UINavigationController *nc = nil;
    while (true) {
        if ([rootvc isKindOfClass:[UITabBarController class]]) {
            rootvc = ((UITabBarController *)rootvc).selectedViewController;
        } else if ([rootvc isKindOfClass:[UINavigationController class]]) {
            nc = (UINavigationController *)rootvc;
            rootvc = [nc.viewControllers lastObject];
        } else {
            break;
        }
    }
    return nc;
}
/// 找到当前的navigationController,有可能会为空
NS_INLINE UINavigationController* SXValidNC() {
    UIViewController *rootvc = SXRootVC();
    UINavigationController *nc = nil;
    while (rootvc != nil) {
        UINavigationController *validNC_ = _SXValidNC(rootvc);
        if (validNC_) nc = validNC_;
        rootvc = rootvc.presentedViewController;
        if ([rootvc isKindOfClass:[UIAlertController class]]) break;
    }
    return nc;
}

NS_INLINE void SXPush(UIViewController *to) {
    to.hidesBottomBarWhenPushed = YES;
    [SXValidNC() pushViewController:to animated:YES];
}

NS_INLINE void SXPresent(UIViewController *to, BOOL animated, dispatch_block_t completed) {
    if (![to isKindOfClass:[UIAlertController class]]) to.modalPresentationStyle = UIModalPresentationFullScreen;
    [SXValidVC() presentViewController:to animated:animated completion:completed];
}

#endif /* SXNavigationHeader_h */
