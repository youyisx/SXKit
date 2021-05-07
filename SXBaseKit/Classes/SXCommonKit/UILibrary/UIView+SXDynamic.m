//
//  UIView+SXDynamic.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIView+SXDynamic.h"
#import "NSObject+SXDynamic.h"
#import <ReactiveObjC/ReactiveObjC.h>
#define k_sizeChangeHandler_0 @"k_sizeChangeHandler_0"
#define k_layoutSubviews_observers @"k_layoutSubviews_observers"
@implementation UIView (SXDynamic)

- (void)setSizeChangeHandler:(SXSizeChangeHandler)sizeChangeHandler {
    [self sx_setObject:sizeChangeHandler forKey:k_sizeChangeHandler_0];
    if (sizeChangeHandler == nil) return;
    if ([self sx_objectForKey:k_layoutSubviews_observers] != nil) return;
    __block CGSize oldSize_ = self.bounds.size;
    @weakify(self)
    RACDisposable *dis =
    [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        CGSize size = self.bounds.size;
        if (CGSizeEqualToSize(size, oldSize_)) return;
        oldSize_ = size;
        SXSizeChangeHandler handler = [self sizeChangeHandler];
        !handler?:handler(size,self);
    }];
    [self sx_setObject:dis forKey:k_layoutSubviews_observers];
}

- (SXSizeChangeHandler)sizeChangeHandler {
    return [self sx_objectForKey:k_sizeChangeHandler_0];
}

- (void)sx_updateWithModel:(nullable id)model {
#ifdef DEBUG
    self.backgroundColor = [UIColor blackColor];
#endif
}

+ (UINib *)sx_defaultNib{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (instancetype)sx_defaultNibView{
    return [[[self sx_defaultNib] instantiateWithOwner:nil options:nil] firstObject];
}

+ (NSString *)sx_defaultIdentifier{
    return NSStringFromClass([self class]);
}

+ (NSString *)sx_defaultNibIdentifier {
    NSString *identifier = [self sx_defaultIdentifier];
    return [NSString stringWithFormat:@"%@%@",identifier,SXNibIdentifierSuffix];
}

- (void)sx_tapAction:(dispatch_block_t)block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        !block?:block();
    }];
    [self addGestureRecognizer:tap];
}


+ (UIView * (^)(UIColor *_Nullable))sx_view {
    return ^(UIColor *color) {
        UIView *view = [[self class] new];
        if (color) view.sx_backColor(color);
        return view;
    };
}

+ (UIView * (^)(UIColor *_Nullable, CGRect))sx_view1 {
    return ^(UIColor *color, CGRect frame) {
        UIView *view = [[[self class] alloc] initWithFrame:frame];
        if (color) view.sx_backColor(color);
        return view;
    };
}

- (UIView * _Nonnull (^)(UIColor * _Nullable))sx_backColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView * _Nonnull (^)(CGFloat))sx_radius {
    return ^(CGFloat r) {
        self.layer.cornerRadius = r;
        self.layer.masksToBounds = true;
        self.clipsToBounds = true;
        return self;
    };
}

- (UIView * _Nonnull (^)(UIColor * _Nonnull, CGFloat))sx_border {
    return ^(UIColor *color, CGFloat width) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = width;
        return self;
    };
}

- (UIView * (^)(CGRect))sx_frame {
    return ^(CGRect rect) {
        self.frame = rect;
        return self;
    };
}
/// 添加一个宽度约束
- (void)sx_addWidthAttributeLayout:(CGFloat)width {
    NSLayoutConstraint *attribute = [NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1 constant:width];
    [self addConstraint:attribute];
}

/// 添加一个高度约束
- (void)sx_addHeightAttributeLayout:(CGFloat)width {
    NSLayoutConstraint *attribute = [NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1 constant:width];
    [self addConstraint:attribute];
}

- (UIImage *)sx_snapshotLayerImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

@end

