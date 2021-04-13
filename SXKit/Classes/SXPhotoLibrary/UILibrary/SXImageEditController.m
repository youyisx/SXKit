//
//  FAImageEditController.m
//  FansApp
//
//  Created by taihe-imac-ios-01 on 2021/3/12.
//  Copyright © 2021 legendry. All rights reserved.
//

#import "SXImageEditController.h"
#import "SXCommon.h"
#import <Masonry/Masonry.h>
@interface SXDrawLucencyView : UIView
/// 指定透明区域（坐标系为FADrawLucencyView 自身坐标系）
@property (nonatomic, assign) CGRect lucencyFrame;
@end


@implementation SXDrawLucencyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)addArc {
    //中间镂空的矩形框
    CGRect myRect =self.lucencyFrame;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    //镂空
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:rectPath];
    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    
    [self.layer addSublayer:fillLayer];
    CAShapeLayer *storkLayer = [CAShapeLayer layer];
    storkLayer.path = rectPath.CGPath;
    storkLayer.strokeColor = [UIColor whiteColor].CGColor;
    storkLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:storkLayer];
}

@end

@interface SXImageEditController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SXDrawLucencyView *lucencyView;
@end

@implementation SXImageEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SXScreenW, SXScreenH)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.lucencyView = [[SXDrawLucencyView alloc] initWithFrame:self.scrollView.frame];
    CGFloat edge = 20;
    CGFloat luceycyW_ = self.lucencyView.sx_w - (edge * 2);
    CGFloat luceycyH_ = luceycyW_;
    CGRect luceycyRect = CGRectMake(edge, (self.lucencyView.sx_h - luceycyH_) * 0.5, luceycyW_, luceycyH_);
    self.lucencyView.lucencyFrame = luceycyRect;
    [self.lucencyView addArc];
    [self.view addSubview:self.lucencyView];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.scrollView addSubview:self.imageView];
    CGSize imgSize = self.imageView.image.size;
    if (imgSize.width > imgSize.height) {
        CGFloat h_ = luceycyH_;
        CGFloat w_ = imgSize.width / imgSize.height * h_;
        self.imageView.frame = CGRectMake(0, 0, w_, h_);
     
    } else {
        CGFloat w_ = luceycyW_;
        CGFloat h_ = imgSize.height / imgSize.width * w_;
        self.imageView.frame = CGRectMake(0, 0, w_, h_);
    }
    
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.contentInset = UIEdgeInsetsMake(luceycyRect.origin.y, luceycyRect.origin.x, self.lucencyView.sx_h - CGRectGetMaxY(luceycyRect), self.lucencyView.sx_w - CGRectGetMaxX(luceycyRect));
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width - self.scrollView.sx_w) *0.5, (self.scrollView.contentSize.height - self.scrollView.sx_h) *0.5);
    self.scrollView.minimumZoomScale = 1;
    CGFloat maxScale = ceil(imgSize.width / self.imageView.sx_w);
    self.scrollView.maximumZoomScale = maxScale < 2 ? 2 : maxScale;
    
    UIView *bottomBar = [UIView new];
    bottomBar.backgroundColor = UIColor.blackColor;
    [self.view addSubview:bottomBar];
    CGFloat bottomBarHeight = SXAdjustP(80);
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(SXSafeBottomHeight + bottomBarHeight);
    }];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancel addTarget:self action:@selector(sx_goBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(SXAdjustP(60));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(SXAdjustP(40));
    }];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setTitle:@"选择" forState:UIControlStateNormal];
    [done setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    done.titleLabel.font = [UIFont systemFontOfSize:18];
    [done addTarget:self action:@selector(clickedDone) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:done];
    [done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-SXAdjustP(60));
        make.width.top.height.mas_equalTo(cancel);
        make.leading.mas_equalTo(cancel.mas_trailing);
    }];
    
}

- (void)clickedDone {
    if (self.cutCallBack == nil) return;
    CGRect cutRect = self.lucencyView.lucencyFrame;
    cutRect = [self.imageView convertRect:cutRect fromView:self.lucencyView];
    CGSize imgSize = self.imageView.image.size;
    /// 图片与 控件的比例
    CGFloat scale = imgSize.width / self.imageView.sx_w * self.scrollView.zoomScale;
    /// 将剪裁区域坐标转换到图片尺寸上
    cutRect = CGRectMake(cutRect.origin.x * scale, cutRect.origin.y * scale, cutRect.size.width * scale, cutRect.size.height * scale);
    cutRect = CGRectIntersection(cutRect, CGRectMake(0, 0, imgSize.width, imgSize.height));
    if (CGRectIsNull(cutRect) || CGRectIsEmpty(cutRect)) return;
    self.cutCallBack(self.imageView.image,cutRect,self);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    /// 结束缩放
}


@end
