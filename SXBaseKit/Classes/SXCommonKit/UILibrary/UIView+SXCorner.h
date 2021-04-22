//
//  UIView+SXCorner.h
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXCorner)

- (void)sx_addCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br;

- (void)sx_addCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br size:(CGSize)size;
/// 会自动根据bounds的变化  而更新corner
- (void)sx_addAutoCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br;

- (void)sx_addCorner:(CGFloat)corner;

@end

NS_ASSUME_NONNULL_END
