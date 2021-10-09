//
//  UIView+SXTransform.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/10/9.
//

#import "UIView+SXTransform.h"

@implementation UIView (SXTransform)

- (CGFloat)sx_scaleX {
    return self.transform.a;
}

- (CGFloat)sx_scaleY {
    return self.transform.d;
}

- (CGFloat)sx_translationX {
    return self.transform.tx;
}

- (CGFloat)sx_translationY {
    return self.transform.ty;
}

@end
