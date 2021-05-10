//
//  SXModalPresentation.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/5/8.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXModalPresentation.h"
#import <SXCommon.h>
@interface SXModelPresentationVal()
@property (nonatomic, copy) dispatch_block_t privateWillHideBlock;
@property (nonatomic, copy) dispatch_block_t privateDidHideBlock;
@property (nonatomic, strong) UIViewController *target;
@end

@implementation SXModelPresentationVal

+ (instancetype)defaultVal {
    SXModelPresentationVal *val = [SXModelPresentationVal new];
    val.sliderSize = CGSizeMake(47, 5);
    val.sliderColor = [UIColor colorWithRed:228/255.0 green:231/255.0 blue:237/255.0 alpha:1];
    val.contentEdge = UIEdgeInsetsMake(25, 0, 0, 0);
    val.contentBackColor = [UIColor whiteColor];
    val.topCornerRadius = 20;
    val.maskColor = [UIColor colorWithWhite:0 alpha:0.7];
    val.heightScale = 0.885;
    val.hidenWhenTouchMask = NO;
    return val;
}

- (void)dealloc {
    NSLog(@"--- %s",__FUNCTION__);
}

@end

@interface SXModalPresentationContentView : UIView
@property (nonatomic, assign) CGFloat cy;
@property (nonatomic, copy) void(^moveHideCallBack)(SXModalPresentationContentView *view);
/// 0 朝上 1 朝下
@property (nonatomic, assign) NSInteger moveDirection;
@end


@implementation SXModalPresentationContentView

- (void)dealloc {
    NSLog(@"--- %s",__FUNCTION__);
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configContentView];
    return self;
}

- (void)configContentView {
    UIPanGestureRecognizer *gesture = [UIPanGestureRecognizer new];
    [gesture addTarget:self action:@selector(_moveGesture:)];
    [self addGestureRecognizer:gesture];
}

- (void)_moveGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.cy = self.center.y;
            self.moveDirection = 0;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = self.center;
            p.y += point.y;
            if (p.y < self.cy) p.y = self.cy;
            self.moveDirection = p.y > self.center.y ? 1 : 0;
            self.center = p;
        }
            
            break;
        default:
        {
            CGFloat y = self.center.y;
            if (y > self.cy + 8 && self.moveDirection == 1) {
                !self.moveHideCallBack?:self.moveHideCallBack(self);
            } else {
                CGPoint p = self.center;
                p.y = self.cy;
                [UIView animateWithDuration:0.25 animations:^{
                    self.center = p;
                }];
            }
            
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

@end

@implementation SXModalPresentation

+ (void)presentationWithViewController:(UIViewController *)vc val:(SXModelPresentationVal * _Nullable)val completed:(void (^ _Nullable)(BOOL))completed{
    if (vc == nil) {
        !completed?:completed(NO);
        return;
    }
    SXModelPresentationVal *uiVal = val ? val : [SXModelPresentationVal defaultVal];
//    UIViewController *rootVC = SXRootVC();
//    [rootVC addChildViewController:vc];
    uiVal.target = vc;
    [self presentationWithView:vc.view val:uiVal completed:^(BOOL success) {
        if (success) {
//            [vc didMoveToParentViewController:rootVC];
        } else {
//            [vc removeFromParentViewController];
            uiVal.target = nil;
        }
        !completed?:completed(success);
    }];
    uiVal.privateWillHideBlock = ^{
//        [vc willMoveToParentViewController:nil];
    };
    @weakify(uiVal)
    uiVal.privateDidHideBlock = ^{
        @strongify(uiVal)
//        [vc removeFromParentViewController];
        uiVal.target = nil;
    };
}

+ (void)presentationWithView:(UIView *)view val:(SXModelPresentationVal * _Nullable)val completed:(void (^ _Nullable)(BOOL))completed{
    if (view == nil) {
        !completed?:completed(NO);
        return;
    }
    SXModelPresentationVal *uiVal = val ? val : [SXModelPresentationVal defaultVal];
    
    void(^hideBlock)(UIView *maskView, UIView *contentView) = ^(UIView *maskView, UIView *contentView) {
        [UIView animateWithDuration:0.25 animations:^{
            maskView.alpha = 0.3;
            contentView.transform = CGAffineTransformMakeTranslation(0, contentView.bounds.size.height);
        } completion:^(BOOL finished) {
            !uiVal.privateWillHideBlock?:uiVal.privateWillHideBlock();
            [contentView removeFromSuperview];
            !uiVal.privateDidHideBlock?:uiVal.privateDidHideBlock();
            [UIView animateWithDuration:0.1 animations:^{
                maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [maskView removeFromSuperview];
                !uiVal.didHideBlock?:uiVal.didHideBlock();
            }];
        }];
    };
    
    
    UIView *rootView =SXRootWindow();
    UIButton *maskBtn = UIButton.sx_button(nil);
    maskBtn.sx_frame(rootView.bounds).sx_backColor(uiVal.maskColor);
    [rootView addSubview:maskBtn];
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(rootView.bounds), CGRectGetHeight(rootView.bounds) * uiVal.heightScale);
    CGRect contentRect = CGRectMake(0, CGRectGetHeight(rootView.bounds) - contentSize.height, contentSize.width, contentSize.height);
    
    SXModalPresentationContentView *contentView = [[SXModalPresentationContentView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = uiVal.contentBackColor;
    if (uiVal.topCornerRadius > 0) [contentView sx_addCornerLayerWithtl:uiVal.topCornerRadius tr:uiVal.topCornerRadius bl:0 br:0 size:contentSize];
    [rootView addSubview:contentView];
    
    if (!CGSizeEqualToSize(CGSizeZero, uiVal.sliderSize) && uiVal.sliderColor) {
        UIView *slider = UIView.sx_view(uiVal.sliderColor).sx_frame(CGRectMake(0, 0, uiVal.sliderSize.width, uiVal.sliderSize.height)).sx_radius(uiVal.sliderSize.height * 0.5);
        slider.userInteractionEnabled = NO;
        [contentView addSubview:slider];
        slider.center = CGPointMake(contentSize.width * 0.5, uiVal.contentEdge.top * 0.5);
    }
    [contentView addSubview:view];
    view.frame = CGRectMake(uiVal.contentEdge.left,
                            uiVal.contentEdge.top,
                            contentSize.width - uiVal.contentEdge.left - uiVal.contentEdge.right,
                            contentSize.height - uiVal.contentEdge.top - uiVal.contentEdge.bottom);
    
    @weakify(maskBtn)
    contentView.moveHideCallBack = ^(SXModalPresentationContentView *view) {
        @strongify(maskBtn)
        hideBlock(maskBtn,view);
    };
    
    @weakify(contentView)
    [[maskBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(contentView)
        if (!uiVal.hidenWhenTouchMask) return;
        hideBlock(x,contentView);
    }];
    
    
    contentView.transform = CGAffineTransformMakeTranslation(0, contentSize.height);
    maskBtn.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        maskBtn.alpha = 1;
        contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        !completed?:completed(YES);
    }];
    
}

@end
