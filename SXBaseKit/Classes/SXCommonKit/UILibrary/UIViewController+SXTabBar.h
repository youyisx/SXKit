//
//  UIViewController+SXTabBar.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SXTabBar)

@property (nonatomic, nullable, readonly) UITabBarItem * sx_tabBarItem;

/** 查找控制器在tabBar上对应的位置
 @Return tabBar对应的下标位置，如果未找到则返回-1
 */
- (NSInteger)sx_indexInTabBarController;
@end

NS_ASSUME_NONNULL_END
