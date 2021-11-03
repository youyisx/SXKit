//
//  SXVCAnimatedTransitioning.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/11/1.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SXVCTransitioningAnimation)(UIView * _Nonnull targetView,
                                          UIView * _Nullable overlayView,
                                          CGSize containerSize,
                                          NSTimeInterval animationDuration,
                                          void(^ _Nonnull completed)(BOOL sucess));
typedef NS_ENUM(NSInteger, SXVCTransitioningLayoutType) {
    /// 容器size发生变化
    SXVCTransitioningLayoutType_SizeChange = 0,
    /** 重新被添加到superView上
     *  在当前的自定义跳转控制器上，如果继续用正常的方式present一个新的controller，那么当前这个自定义控制器会被系统从容器view中移除
     *  当新的controller dismiss掉了，自定义控制器会被重新添加到容器中）
     */
    SXVCTransitioningLayoutType_MoveToSuperview  = 1,
    /// 键盘发生变化
    SXVCTransitioningLayoutType_KeyboardChange = 2,
};
typedef void(^SXVCTransitioningLayout) (UIView * _Nonnull targetView,
                                        UIView * _Nullable overlayView,
                                        CGSize containerSize,
                                        CGFloat keyboardHeight,
                                        SXVCTransitioningLayoutType layoutType);
typedef NS_ENUM(NSInteger, SXVCAnimatedTransitionType) {
    SXVCAnimatedTransitioning_Show = 0,
    SXVCAnimatedTransitioning_Hidden = 1
};
NS_ASSUME_NONNULL_BEGIN

@interface SXVCAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, readonly) SXVCAnimatedTransitionType type;
@property (nonatomic, copy) SXVCTransitioningAnimation animationBlock;
@property (nonatomic, copy) SXVCTransitioningLayout layoutBlock;
+ (instancetype)animatedTransitioning:(SXVCAnimatedTransitionType)type;

@end

NS_ASSUME_NONNULL_END
