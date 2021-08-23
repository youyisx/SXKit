//
//  UIViewController+SXTabBar.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/8/23.
//

#import "UIViewController+SXTabBar.h"

@implementation UIViewController (SXTabBar)
@dynamic sx_tabBarItem;

- (NSInteger)sx_indexInTabBarController {
    NSArray <UIViewController *>*controllers = self.tabBarController.viewControllers;
    for (int i = 0; i < controllers.count; i++) {
        UIViewController *vc = controllers[i];
        if (vc == self) return i;
        if ([vc isKindOfClass:[UINavigationController class]]
            && self.navigationController == vc) {
            return i;
        }
    }
    return -1;
}

- (UITabBarItem *)sx_tabBarItem {
    NSInteger idx = [self sx_indexInTabBarController];
    return idx < 0 ? nil : self.tabBarController.tabBar.items[idx];
}

@end
