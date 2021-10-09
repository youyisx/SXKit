//
//  UIView+SXFrame.m
//  SXKit
//
//  Created by vince_wang on 2021/4/9.
//

#import "UIView+SXFrame.h"

@implementation UIView (SXFrame)
@dynamic sx_x,sx_y,sx_w,sx_h,sx_centerX,sx_centerY,sx_right,sx_bottom,sx_size,sx_extendToTop,sx_extendToBottom,sx_extendToLeft,sx_extendToRight,sx_centerTopInSuperview,sx_centerLeftInSuperView;

- (void)setSx_x:(CGFloat)sx_x {
    CGRect frame = self.frame;
    frame.origin.x = sx_x;
    self.frame = frame;
}

- (CGFloat)sx_x {
    return self.frame.origin.x;
}

- (void)setSx_y:(CGFloat)sx_y {
    CGRect frame = self.frame;
    frame.origin.y = sx_y;
    self.frame = frame;
}

- (CGFloat)sx_y {
    return self.frame.origin.y;
}

- (void)setSx_w:(CGFloat)sx_w {
    CGRect frame = self.frame;
    frame.size.width = sx_w;
    self.frame = frame;
}

- (CGFloat)sx_w {
    return self.frame.size.width;
}

- (void)setSx_h:(CGFloat)sx_h {
    CGRect frame = self.frame;
    frame.size.height = sx_h;
    self.frame = frame;
}

- (CGFloat)sx_h {
    return self.frame.size.height;
}

- (void)setSx_centerX:(CGFloat)sx_centerX {
    CGPoint p = self.center;
    p.x = sx_centerX;
    self.center = p;
}

- (CGFloat)sx_centerX {
    return self.center.x;
}

- (void)setSx_centerY:(CGFloat)sx_centerY {
    CGPoint p = self.center;
    p.y = sx_centerY;
    self.center = p;
}

- (CGFloat)sx_centerY {
    return self.center.y;
}

- (void)setSx_right:(CGFloat)sx_right {
    self.sx_x = sx_right - self.sx_w;
}

- (CGFloat)sx_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setSx_bottom:(CGFloat)sx_bottom {
    self.sx_y = sx_bottom - self.sx_h;
}

- (CGFloat)sx_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setSx_size:(CGSize)sx_size {
    CGRect frame = self.frame;
    frame.size = sx_size;
    self.frame = frame;
}

- (CGSize)sx_size {
    return self.frame.size;
}

- (void)setSx_extendToTop:(CGFloat)sx_extendToTop {
    CGFloat temp = self.sx_bottom - sx_extendToTop;
    self.sx_h = temp > 0 ? temp : 0;
    self.sx_y = sx_extendToTop;
}

- (CGFloat)sx_extendToTop {
    return self.sx_y;
}

- (void)setSx_extendToBottom:(CGFloat)sx_extendToBottom {
    CGFloat temp = sx_extendToBottom - self.sx_y;
    self.sx_h = temp > 0 ? temp : 0;
    self.sx_bottom = sx_extendToBottom;
}

- (CGFloat)sx_extendToBottom {
    return self.sx_bottom;
}

- (void)setSx_extendToLeft:(CGFloat)sx_extendToLeft {
    CGFloat temp = self.sx_right - sx_extendToLeft;
    self.sx_w = temp > 0 ? temp : 0;
    self.sx_x = sx_extendToLeft;
}

- (CGFloat)sx_extendToLeft {
    return self.sx_x;
}

- (void)setSx_extendToRight:(CGFloat)sx_extendToRight {
    CGFloat temp = sx_extendToRight - self.sx_x;
    self.sx_w = temp > 0 ? temp : 0;
    self.sx_right = sx_extendToRight;
}

- (CGFloat)sx_extendToRight {
    return self.sx_right;
}

- (CGFloat)sx_centerLeftInSuperView {
    return (CGRectGetWidth(self.superview.bounds) - CGRectGetWidth(self.frame)) * 0.5;
}

- (CGFloat)sx_centerTopInSuperview {
    return (CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(self.frame)) * 0.5;
}

@end
