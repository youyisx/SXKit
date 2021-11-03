//
//  UIViewController+SXTransitioning.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/11/1.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVCTransitioningHandle.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SXTransitioning)
/// 自定义 present model 跳转
@property (nonatomic, strong)id<UIViewControllerTransitioningDelegate> sx_transitioningDelegate;

- (void)sx_presentViewController:(UIViewController *)controller
                   transitioning:(SXVCTransitioningHandle *)transitioning
                      completion:(dispatch_block_t)completion;
@end

NS_ASSUME_NONNULL_END
