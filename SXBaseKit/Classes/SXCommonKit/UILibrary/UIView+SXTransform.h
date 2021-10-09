//
//  UIView+SXTransform.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXTransform)

/// 获取当前 view 的 transform scale x
@property(nonatomic, readonly) CGFloat sx_scaleX;

/// 获取当前 view 的 transform scale y
@property(nonatomic, readonly) CGFloat sx_scaleY;

/// 获取当前 view 的 transform translation x
@property(nonatomic, readonly) CGFloat sx_translationX;

/// 获取当前 view 的 transform translation y
@property(nonatomic, readonly) CGFloat sx_translationY;

@end

NS_ASSUME_NONNULL_END
