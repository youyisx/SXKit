//
//  SXProgressLayer.m
//  WebTVPlayer
//
//  Created by 王浪 on 15/1/21.
//  Copyright (c) 2015年 vince. All rights reserved.
//

#import "SXProgress.h"
@interface SXProgress()
@property(nonatomic,strong)CALayer * progressLayer;
@property(nonatomic,strong)CALayer * downLayer;
@end

@implementation SXProgress
@dynamic progressColor, downProgressColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParameter];
    }
    return self;
}
-(void)initParameter{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}
#pragma mark get方法
-(CALayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CALayer layer];
    }
    if (!_progressLayer.superlayer) {
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}
-(CALayer *)downLayer{
    if (!_downLayer) {
        _downLayer = [CALayer layer];
    }
    if (!_downLayer.superlayer) {
        [self.layer insertSublayer:_downLayer below:self.progressLayer];
    }
    return _downLayer;
}

- (void)setProgressColor:(UIColor *)progressColor {
    self.progressLayer.backgroundColor = progressColor.CGColor;
}

- (UIColor *)progressColor {
    return [UIColor colorWithCGColor:self.progressLayer.backgroundColor];
}

- (UIColor *)downProgressColor {
    return [UIColor colorWithCGColor:self.downLayer.backgroundColor];
}

- (void)setDownProgressColor:(UIColor *)downProgressColor {
    self.downLayer.backgroundColor = downProgressColor.CGColor;
}
#pragma mark set方法
-(void)setProgress:(CGFloat)progress{
    if (progress>1) {
        _progress = 1;
    }else if (progress<0){
        _progress = 0;
    }else{
        _progress = progress;
    }
    if ([[NSThread currentThread] isMainThread]) {
        [self setProgressToLayer];
    }else{
        [self performSelectorOnMainThread:@selector(setProgressToLayer) withObject:nil waitUntilDone:YES];
    }
}
-(void)setDownProgress:(CGFloat)downProgress{
    
    if (downProgress>1) {
        _downProgress = 1;
    }else if (downProgress<0){
        _downProgress = 0;
    }else{
        _downProgress = downProgress;
    }
    if ([[NSThread currentThread] isMainThread]) {
        [self setDownProgressToLayer];
    }else{
        [self performSelectorOnMainThread:@selector(setDownProgressToLayer) withObject:nil waitUntilDone:YES];
    }
}
#pragma mark 进度执行方法
-(void)setProgressToLayer {
    CGFloat tempWidth = CGRectGetWidth(self.bounds)*self.progress;
    if (tempWidth == CGRectGetWidth(self.progressLayer.frame)) return;
    self.progressLayer.frame = CGRectMake(0, 0, tempWidth, CGRectGetHeight(self.bounds));
}
-(void)setDownProgressToLayer{
    CGFloat tempWidth = CGRectGetWidth(self.bounds)*self.downProgress;
    if (tempWidth == CGRectGetWidth(self.downLayer.frame)) return;
    self.downLayer.frame = CGRectMake(0, 0, tempWidth, CGRectGetHeight(self.bounds));
}
#pragma mark 布局方法
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setProgressToLayer];
    [self setDownProgressToLayer];
}
@end


@interface SXProgressSlider()

@end
@implementation SXProgressSlider
@dynamic progressHeight;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configUI];
    return self;
}

- (void)setProgressHeight:(CGFloat)progressHeight {
    CGRect r = self.progress.frame;
    if (r.size.height == progressHeight) return;
    r.size.height = progressHeight;
    r.origin.y = (CGRectGetHeight(self.bounds) - progressHeight) * 0.5;
    self.progress.frame = r;
    self.progress.layer.cornerRadius = progressHeight * 0.5;
}

- (CGFloat)progressHeight {
    return self.progress.frame.size.height;
}

- (void)configUI {
    self.progress = [[SXProgress alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 3)];
    [self setProgressHeight:3];
    [self addSubview:self.progress];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.point = [UIView new];
    [self.point addGestureRecognizer:gesture];
    self.point.backgroundColor = [UIColor whiteColor];
    self.point.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    self.point.layer.borderWidth = 3;
    [self addSubview:self.point];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalH = CGRectGetHeight(self.bounds);
    if (totalH != CGRectGetHeight(self.point.frame)) {
        self.point.layer.cornerRadius = totalH * 0.5;
        CGRect r = self.point.frame;
        r.size = CGSizeMake(totalH, totalH);
        self.point.frame = r;
    }
    CGFloat totalw = CGRectGetWidth(self.bounds);
    CGFloat ph = CGRectGetHeight(self.progress.frame);
    self.progress.frame = CGRectMake(totalH * 0.5, (totalH - ph) * 0.5, totalw - totalH, ph);
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            !self.willSeek?:self.willSeek();
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = self.point.center;
            p = CGPointMake(p.x + point.x, p.y);
            CGFloat px = [self.progress convertPoint:p fromView:self.point.superview].x;
            if (px < 0) px = 0;
            CGFloat value = [self seek:px/CGRectGetWidth(self.progress.bounds)];
            !self.doSeek?:self.doSeek(value);
        }
            
            break;
        default:
        {
            !self.endSeek?:self.endSeek();
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

/// 0 ~1
- (CGFloat)seek:(CGFloat)seek {
    CGFloat value = seek;
    if (value > 1) value = 1;
    if (value < 0) value = 0;
    self.progress.progress = value;
    
    CGFloat px = CGRectGetWidth(self.progress.bounds) * value;
    CGPoint p = CGPointMake(px, 0);
    p.x = [self convertPoint:p fromView:self.progress].x;
    p.y = self.progress.center.y;
    self.point.center = p;
    return value;
}
@end


