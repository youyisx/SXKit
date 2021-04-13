//
//  UIView+SXFrame.m
//  SXKit
//
//  Created by vince_wang on 2021/4/9.
//

#import "UIView+SXFrame.h"

@implementation UIView (SXFrame)
@dynamic sx_x,sx_y,sx_w,sx_h,sx_centerX,sx_centerY;

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
    return CGRectGetWidth(self.bounds);
}

- (void)setSx_h:(CGFloat)sx_h {
    CGRect frame = self.frame;
    frame.size.height = sx_h;
    self.frame = frame;
}

- (CGFloat)sx_h {
    return CGRectGetHeight(self.bounds);
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

@end
