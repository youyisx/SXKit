//
//  SXVCTransitioningHandle.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SXPresentationOverlaySource.h"
#import "SXVCAnimatedTransitioning.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVCTransitioningHandle : NSObject<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) SXPresentationOverlaySource *overlaySource;

/// 配置展示动画
- (void)configShowAnimation:(SXVCTransitioningAnimation)animation;
/// 配置隐藏动画
- (void)configHideAnimation:(SXVCTransitioningAnimation )animation;
/// 容器布局发生变化时的回调处理逻辑
- (void)configLayout:(SXVCTransitioningLayout)layout;

@end

NS_ASSUME_NONNULL_END
