//
//  UITabBar+SXDynamic.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (SXDynamic)

@property (nonatomic) UIColor *sx_redDotColor;
/// tabbarItem上小红点的显示
- (void)sx_tabBarRedDot:(BOOL)isShow index:(NSInteger)index;
/// 获取tabbarItem上的图片控件
- (UIView *_Nullable)sx_tabBarItemIconWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
