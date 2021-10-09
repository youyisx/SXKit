//
//  UIView+SXFrame.h
//  SXKit
//
//  Created by vince_wang on 2021/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXFrame)
@property (nonatomic) CGFloat sx_x;
@property (nonatomic) CGFloat sx_y;
@property (nonatomic) CGFloat sx_w;
@property (nonatomic) CGFloat sx_h;
@property (nonatomic) CGFloat sx_centerX;
@property (nonatomic) CGFloat sx_centerY;
/// 等价于 CGRectGetMaxX(frame)
@property (nonatomic) CGFloat sx_right;
/// 等价于 CGRectGetMaxY(frame)
@property (nonatomic) CGFloat sx_bottom;
/// 等价于 self.frame.size
@property (nonatomic) CGSize  sx_size;
/// 保持其他三个边缘的位置不变的情况下，将顶边缘拓展到某个指定的位置，注意高度会跟随变化。
@property (nonatomic) CGFloat sx_extendToTop;
/// 保持其他三个边缘的位置不变的情况下，将底边缘拓展到某个指定的位置，注意高度会跟随变化。
@property (nonatomic) CGFloat sx_extendToBottom;
/// 保持其他三个边缘的位置不变的情况下，将左边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property (nonatomic) CGFloat sx_extendToLeft;
/// 保持其他三个边缘的位置不变的情况下，将右边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property (nonatomic) CGFloat sx_extendToRight;

/// 获取当前 view 在 superview 内水平居中时的 left
@property (nonatomic, readonly) CGFloat sx_centerLeftInSuperView;
/// 获取当前 view 在 superview 内垂直居中时的 top
@property (nonatomic, readonly) CGFloat sx_centerTopInSuperview;
@end

NS_ASSUME_NONNULL_END
