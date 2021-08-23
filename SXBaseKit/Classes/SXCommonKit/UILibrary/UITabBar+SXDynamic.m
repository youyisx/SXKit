//
//  UITabBar+SXDynamic.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/8/23.
//

#import "UITabBar+SXDynamic.h"
#import <objc/runtime.h>

static void *k_sx_redDotColor = &k_sx_redDotColor;
static void *k_sx_tabBarHotDotKey = &k_sx_tabBarHotDotKey;
@implementation UITabBar (SXDynamic)
@dynamic sx_redDotColor;

- (UIColor *)sx_redDotColor {
    UIColor *color = objc_getAssociatedObject(self, k_sx_redDotColor);
    return [color isKindOfClass:[UIColor class]] ? color : UIColor.redColor;
}

- (void)setSx_redDotColor:(UIColor *)sx_redDotColor {
    objc_setAssociatedObject(self, k_sx_redDotColor, sx_redDotColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sx_tabBarRedDot:(BOOL)isShow index:(NSInteger)index {
    UIView *barBtn = [self sx_tabBarButtonInIndex:index];
    if (!barBtn) return;
    NSMutableDictionary *hotDots = objc_getAssociatedObject(self, k_sx_redDotColor);
    if (hotDots == nil) {
        hotDots = [NSMutableDictionary dictionaryWithCapacity:5];
        objc_setAssociatedObject(self, k_sx_redDotColor, hotDots, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UIView *hotDot = hotDots[@(index).stringValue];
    if (!isShow) {
        hotDot.hidden = YES;
        return;
    }
    if (!hotDot) {
        hotDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        hotDot.layer.cornerRadius = 3;
        hotDot.backgroundColor = self.sx_redDotColor;
        hotDots[@(index).stringValue] = hotDot;
        [self addSubview:hotDot];
    }
    CGPoint p = CGPointZero;
    for (UIView *imageView in barBtn.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            p = CGPointMake(CGRectGetMaxX(imageView.bounds), CGRectGetMinX(imageView.bounds));
            p = [self convertPoint:p fromView:imageView];
            break;
        }
    }
    hotDot.frame = CGRectMake(p.x - 3, p.y, 6, 6);
    hotDot.hidden = NO;
    [self bringSubviewToFront:hotDot];
}

- (UIView *)sx_tabBarItemIconWithIndex:(NSInteger)index {
    UIView *barBtn = [self sx_tabBarButtonInIndex:index];
    for (UIView *imageView in barBtn.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            return imageView;
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            animation.toValue = @(M_PI * 2);
//            animation.duration = 0.5;
//            [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
        }
    }
    return nil;
}


- (UIView *_Nullable)sx_tabBarButtonInIndex:(NSInteger)index {
    NSMutableArray<UIView *> *tabBarBtns = [NSMutableArray arrayWithCapacity:5];
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) [tabBarBtns addObject:btn];
    }
    [tabBarBtns sortUsingComparator:^NSComparisonResult(UIView *_Nonnull obj1, UIView *_Nonnull obj2) {
        return CGRectGetMidX(obj1.frame) > CGRectGetMidX(obj2.frame);
    }];
    return (tabBarBtns.count > index && index >= 0) ? tabBarBtns[index] : nil;
}

@end
