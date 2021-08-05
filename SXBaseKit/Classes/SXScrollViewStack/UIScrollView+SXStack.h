//
//  UIScrollView+SXStack.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/8/4.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SXStack.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SXStack)

@property (nonatomic) NSArray<UIView *> *arrangedSubviews;
/// 默认为YES ，添加/移除/高度变化 会通过动画更新
@property (nonatomic) BOOL animationUpdate;

- (void)addArrangedSubview:(UIView *)view;

- (void)removeArrangedSubview:(UIView *)view;

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;
/// 如果不存在，则返回-1
- (NSInteger)indexOfArrangeView:(UIView *)view;

- (void)layoutArrangeSubviews ;
- (void)layoutArrangeSubviewsFromIndex:(NSInteger)stackIndex;
- (void)layoutArrangeSubviewsFromView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
