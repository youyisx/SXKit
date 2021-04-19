//
//  UIView+SXAlert.m
//  VSocial
//
//  Created by vince on 2021/3/16.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIView+SXAlert.h"
#import "SXNavigationHeader.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
@implementation UIView (SXAlert)
@dynamic sx_alertBack, sx_alertPosition,sx_hideWhenTouchBack,sx_hideCompleted;

- (void)setSx_hideCompleted:(dispatch_block_t)sx_hideCompleted {
    objc_setAssociatedObject(self, "k_sx_hideCompleted", sx_hideCompleted, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)sx_hideCompleted {
    return objc_getAssociatedObject(self, "k_sx_hideCompleted");
}

- (void)setSx_hideWhenTouchBack:(BOOL)sx_hideWhenTouchBack {
    objc_setAssociatedObject(self, "k_sx_hideWhenTouchBack", @(sx_hideWhenTouchBack), OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.sx_alertBack.userInteractionEnabled = sx_hideWhenTouchBack;
}

- (BOOL)sx_hideWhenTouchBack {
    return [objc_getAssociatedObject(self, "k_sx_hideWhenTouchBack") boolValue];
}

- (void)setSx_alertPosition:(NSInteger)sx_alertPosition {
    objc_setAssociatedObject(self, "k_sx_alertPosition", @(sx_alertPosition), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)sx_alertPosition {
    return [objc_getAssociatedObject(self, "k_sx_alertPosition") integerValue];
}

- (void)setSx_alertBack:(UIButton *)sx_alertBack {
    objc_setAssociatedObject(self, "k_sx_alertBack", sx_alertBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)sx_alertBack {
    return objc_getAssociatedObject(self, "k_sx_alertBack");
}

- (void)sx_alertShow {
    if (self.sx_alertBack) return;
    UIView *window = SXRootWindow();
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    back.frame = window.bounds;
    [window addSubview:back];
    [window addSubview:self];
    self.sx_alertBack = back;
    self.sx_alertBack.userInteractionEnabled = self.sx_hideWhenTouchBack;
    [self.sx_alertBack addTarget:self action:@selector(sx_alertHide) forControlEvents:UIControlEventTouchUpInside];
    CGPoint offset = CGPointZero;
    if (self.sx_alertPosition == 1) {
        CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        offset.y = (CGRectGetHeight(window.bounds) - size.height) * 0.5;
        self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(window.bounds));
    } else {
        self.alpha = 0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.45, 0.45);
    }
    back.alpha = 0;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(window).centerOffset(offset);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        back.alpha = 1;
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}


- (void)sx_alertHide {
    [self sx_alertHideWithCompleted:nil];
}

- (void)sx_alertHideWithCompleted:(dispatch_block_t)completed {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat alpha = 1;
    if (self.sx_alertPosition == 1) {
        CGFloat offsety = CGRectGetHeight(self.superview.bounds) - CGRectGetMinY(self.frame);
        transform = CGAffineTransformMakeTranslation(0, offsety);
    } else {
        alpha = 0.1;
        transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.45, 0.45);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.sx_alertBack.alpha = 0.45;
        self.transform = transform;
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.sx_alertBack.alpha = 0;
        } completion:^(BOOL finished) {
            [self sx_doneRemoveCompleted:completed];
        }];
    }];
}

- (void)sx_doneRemoveCompleted:(dispatch_block_t)completed {
    [self.sx_alertBack removeFromSuperview];
    self.sx_alertBack = nil;
    [self removeFromSuperview];
    !completed?:completed();
    !self.sx_hideCompleted?:self.sx_hideCompleted();
}


@end
