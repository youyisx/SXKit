//
//  SXVideoTrimmerView.m
//  SXMovieCutDemo
//
//  Created by vince_wang on 2021/3/26.
//

#import "SXVideoTrimmerView.h"
#import <SXBaseKit/NSBundle+SXDynamic.h>
@interface SXVideoTrimmerMaskView : UIView
@property (nonatomic, strong) UIImageView *rightSlider;
@property (nonatomic, strong) UIImageView *leftSlider;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@end

@implementation SXVideoTrimmerMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configUI];
    return self;
}

- (void)configUI {
    self.clipsToBounds = NO;

    /// 58,93,231
    UIColor *bgColor = [UIColor colorWithRed:58/255.0 green:93/255.0 blue:231/255.0 alpha:1];
    self.topLine = [UIView new];
    self.topLine.backgroundColor = bgColor;
    [self addSubview:self.topLine];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = bgColor;
    [self addSubview:self.bottomLine];
    
    self.leftLine = [UIView new];
    self.leftLine.backgroundColor = bgColor;
    self.leftLine.layer.cornerRadius = 2;
    [self addSubview:self.leftLine];
    
    self.rightLine = [UIView new];
    self.rightLine.layer.cornerRadius = 2;
    self.rightLine.backgroundColor = bgColor;
    [self addSubview:self.rightLine];
     
    self.rightSlider = [[UIImageView alloc] initWithImage:[[NSBundle bundleForClass:[self class]] sx_img:@"sx_icon_seekbar"]];
    self.rightSlider.userInteractionEnabled = true;
    self.rightSlider.contentMode = UIViewContentModeCenter;
    
    self.leftSlider = [[UIImageView alloc] initWithImage:[[NSBundle bundleForClass:[self class]] sx_img:@"sx_icon_seekbar"]];
    self.leftSlider.userInteractionEnabled = true;
    self.leftSlider.contentMode = UIViewContentModeCenter;
    
    self.slider = [UIView new];
    self.slider.backgroundColor = [UIColor whiteColor];
    self.slider.layer.cornerRadius = 3;
    
    [self addSubview:self.rightSlider];
    [self addSubview:self.leftSlider];
    [self addSubview:self.slider];
    
   
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalH = CGRectGetHeight(self.bounds);
 
    CGRect lf = self.leftSlider.frame;
    lf.size.height = totalH;
    lf.size.width = self.leftSlider.image.size.width + 6;
    self.leftSlider.frame = lf;
    
    CGRect rf = self.rightSlider.frame;
    rf.size.height = totalH;
    rf.size.width = self.rightSlider.image.size.width + 6;
    self.rightSlider.frame = rf;
    
    CGFloat py = CGRectGetHeight(self.bounds) * 0.5;
    CGFloat px = CGRectGetWidth(self.leftSlider.frame) * 0.5;
    self.leftSlider.center = CGPointMake(px, py);
    self.rightSlider.center = CGPointMake(CGRectGetWidth(self.bounds) - px, py);
    
    
    
    CGFloat lineH = 3;
    CGFloat totalW = CGRectGetWidth(self.bounds);
    self.topLine.frame = CGRectMake(4, 0, totalW - 8, lineH);
    self.bottomLine.frame = CGRectMake(4, totalH -lineH, totalW - 8, lineH);
    
    CGFloat lineW = CGRectGetWidth(self.leftSlider.bounds);
    self.leftLine.frame = CGRectMake(0, 0, lineW, totalH);
    self.leftLine.center = self.leftSlider.center;
    self.rightLine.frame = CGRectMake(0, 0, lineW, totalH);
    self.rightLine.center = self.rightSlider.center;
    
}


@end

@interface SXVideoTrimmerView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SXVideoTrimmerMaskView *maskView;
@property (nonatomic, assign) double maskMinW;
@property (nonatomic, assign) double maskMaxW;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, strong) UIPanGestureRecognizer *leftpangesture;
@property (nonatomic, strong) UIPanGestureRecognizer *rightpangesture;
@property (nonatomic, strong) UIPanGestureRecognizer *centerPangesture;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*frameImages;
@end


@implementation SXVideoTrimmerView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeParams];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initializeParams];
    return self;
}

- (void)initializeParams {
    self.leftEdge = 20;
    self.rightEdge = 20;
    self.minIntervalProgress = 0;
    self.maxIntervalProgress = 1;
    self.frameItemWidth = 40;
}

- (double)minIntervalProgress {
    if (_minIntervalProgress < 0) return 0;
    if (_minIntervalProgress > 1) return 1;
    return _minIntervalProgress;
}

- (double)maxIntervalProgress {
    if (_maxIntervalProgress < 0) return 0;
    if (_maxIntervalProgress > 1) return 1;
    return _maxIntervalProgress;
}

- (void)activeTrimmerView {
    if (self.scrollView) return;
    self.frameImages = [NSMutableArray arrayWithCapacity:self.framesCount];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.decelerationRate = 0.1;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.leftEdge, 0, self.rightEdge);
    [self addSubview:self.scrollView];
    
    CGFloat y = 2;
    CGFloat h = self.scrollView.bounds.size.height - y - y;
    CGFloat w = self.frameItemWidth;
    for (int i = 0; i < self.framesCount; i++) {
        UIImageView *imgview = [UIImageView new];
        imgview.clipsToBounds = true;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.frame = CGRectMake(i * w, y, w, h);
        [self.scrollView addSubview:imgview];
        [self.frameImages addObject:imgview];
    }
    CGFloat totalW = w * self.framesCount;
    CGFloat totalH = self.scrollView.bounds.size.height;
    self.scrollView.contentSize = CGSizeMake(totalW, totalH);
    self.maskMinW = totalW * self.minIntervalProgress;
    self.maskMaxW = totalW * self.maxIntervalProgress;
    
    self.maskView = [[SXVideoTrimmerMaskView alloc] initWithFrame:CGRectMake(0, 0, self.maskMaxW, totalH)];
    [self.scrollView addSubview:self.maskView];
    self.scrollView.delegate = self;
    self.lastOffsetX = self.scrollView.contentOffset.x;
    
    UIPanGestureRecognizer *leftpangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPangesture:)];
    UIPanGestureRecognizer *rightpangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPangesture:)];
    UIPanGestureRecognizer *centerPangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centerPangesture:)];
    centerPangesture.delegate = self;
    UIPanGestureRecognizer *sliderPangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderPangesture:)];
    
    [self.maskView.leftSlider addGestureRecognizer:leftpangesture];
    [self.maskView.rightSlider addGestureRecognizer:rightpangesture];
    [self.maskView addGestureRecognizer:centerPangesture];
    [self.maskView.slider addGestureRecognizer:sliderPangesture];
    self.leftpangesture = leftpangesture;
    self.rightpangesture = rightpangesture;
    self.centerPangesture = centerPangesture;
    
    [self updateDidChangeTrimmerFrame];
}

- (void)setFrame:(UIImage *)image idx:(NSInteger)idx {
    if (idx < 0 || idx >= self.frameImages.count) return;
    self.frameImages[idx].image = image;
}
#pragma mark ---
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.willChangeTrimmerFrame?:self.willChangeTrimmerFrame();
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateMaskViewPosition];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateMaskViewPosition];
    [self updateDidChangeTrimmerFrame];
    !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateMaskViewPosition];
    [self updateDidChangeTrimmerFrame];
    !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
}

- (void)updateMaskViewPosition {
    CGFloat x = self.scrollView.contentOffset.x;
    CGFloat temp =  x - self.lastOffsetX;
    self.lastOffsetX = x;
    
    temp += self.maskView.frame.origin.x;
    if (temp + CGRectGetWidth(self.maskView.frame) > self.scrollView.contentSize.width) {
        temp = self.scrollView.contentSize.width - CGRectGetWidth(self.maskView.frame);
    } else if (temp < 0) {
        temp = 0;
    }
    CGRect frame = self.maskView.frame;
    frame.origin.x = temp;
    self.maskView.frame = frame;
}

- (void)seekSlider:(CGFloat)progress {
    CGFloat x = self.scrollView.contentSize.width * progress;
    CGPoint p = CGPointMake(x, 0);
    p = [self.scrollView convertPoint:p toView:self.maskView];
    x = p.x;
    if (x < 0) {
        x = 0;
    } else if (x + CGRectGetWidth(self.maskView.slider.frame) > CGRectGetWidth(self.maskView.frame)) {
        x = CGRectGetWidth(self.maskView.frame) - CGRectGetWidth(self.maskView.slider.frame);
    }
    CGRect frame = self.maskView.slider.frame;
    frame.origin.x = x;
    self.maskView.slider.frame = frame;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.maskView.slider ||
        view == self.maskView.rightSlider ||
        view == self.maskView.leftSlider) {
        CGRect rf = self.maskView.rightSlider.frame;
        CGRect lf = self.maskView.leftSlider.frame;
        if (CGRectIntersection(rf, lf).size.width > 0) {
            CGRect frame = [self convertRect:self.maskView.bounds fromView:self.maskView];
            CGFloat l = CGRectGetMinX(frame);
            CGFloat r = CGRectGetWidth(self.bounds) - CGRectGetMaxX(frame);
            return l > r ? self.maskView.leftSlider : self.maskView.rightSlider;
        }
        CGRect sf = self.maskView.slider.frame;
        if (view == self.maskView.leftSlider && CGRectIntersection(lf, sf).size.width > 0) return self.maskView.slider;
        if (view == self.maskView.rightSlider && CGRectIntersection(rf, sf).size.width > 0) return self.maskView.slider;
    } else if (view == self.scrollView) {
        CGRect frame = [self convertRect:self.maskView.bounds fromView:self.maskView];
        CGFloat lf = CGRectGetMinX(frame) - 6;
        CGFloat rf = CGRectGetMaxX(frame) + 6;
        CGFloat p = point.x;
        if (p > lf && p < rf)  return (p - lf) < ((rf - lf) * 0.5) ? self.maskView.leftSlider : self.maskView.rightSlider ;
    }
    return view;
}

#pragma mark --- callback
- (void)updateDidChangeTrimmerFrame {
    CGRect sliderFrame = self.maskView.slider.frame;
    sliderFrame.size = CGSizeMake(5, CGRectGetHeight(self.maskView.frame));
    self.maskView.slider.frame = sliderFrame;
    if (!self.didChangeTrimmerFrame) return;
    CGFloat totalw = self.scrollView.contentSize.width;
    CGFloat min = self.maskView.frame.origin.x;
    CGFloat max = CGRectGetMaxX(self.maskView.frame);
    if (max > totalw) max = totalw;
    if (min < 0) min = 0;
    /// 计算slider 对应的seek位置
    CGFloat seek = min + CGRectGetMinX(self.maskView.slider.frame);
    seek = seek/totalw;
    min = min/totalw;
    max = max/totalw;
    self.didChangeTrimmerFrame(min, max, seek);
}
#pragma mark --- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.centerPangesture) {
        if (CGRectGetMaxX(self.maskView.frame) > self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds)) return NO;
        if (CGRectGetMinX(self.maskView.frame) < self.scrollView.contentOffset.x) return NO;
    }
    return true;
}

- (void)leftPangesture:(UIPanGestureRecognizer *)gesture {
    CGFloat x = [gesture translationInView:gesture.view].x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            !self.willChangeTrimmerFrame?:self.willChangeTrimmerFrame();
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat w = self.maskView.frame.size.width;
            w -= x;
            if (w > self.maskMaxW) {
                w = self.maskMaxW;
            } else if (w < self.maskMinW) {
                w = self.maskMinW;
            }
            x = CGRectGetMaxX(self.maskView.frame) - w;
            if (x < 0) {
                x = 0;
                w = self.maskView.frame.size.width;
            }
            /// 判断是否超出屏幕
            if (x - self.leftEdge < self.scrollView.contentOffset.x) return;
            CGRect frame = self.maskView.frame;
            frame.size.width = w;
            frame.origin.x = x;
            self.maskView.frame = frame;
            
            CGRect sliderFrame = self.maskView.slider.frame;
            sliderFrame.origin.x = 0;
            self.maskView.slider.frame = sliderFrame;
            
            [self updateDidChangeTrimmerFrame];
        }
            break;
        default: {
            !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)rightPangesture:(UIPanGestureRecognizer *)gesture {
    CGFloat x = [gesture translationInView:gesture.view].x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            !self.willChangeTrimmerFrame?:self.willChangeTrimmerFrame();
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat w = self.maskView.frame.size.width;
            w += x;
            if (w > self.maskMaxW) {
                w = self.maskMaxW;
            } else if (w < self.maskMinW) {
                w = self.maskMinW;
            }
            x = CGRectGetMinX(self.maskView.frame);
            if(x + w > self.scrollView.contentSize.width) w = self.scrollView.contentSize.width - x;
            /// 判断是否超出屏幕
            CGFloat maxrightX = self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds) - self.rightEdge;
            if (x + w > maxrightX) return;
            CGRect frame = self.maskView.frame;
            frame.size.width = w;
            self.maskView.frame = frame;
            
            CGRect sliderFrame = self.maskView.slider.frame;
            sliderFrame.origin.x = CGRectGetWidth(self.maskView.frame) - CGRectGetWidth(sliderFrame);
            self.maskView.slider.frame = sliderFrame;
            
            [self updateDidChangeTrimmerFrame];
        }
            break;
        default:{
            !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)centerPangesture:(UIPanGestureRecognizer *)gesture {
    CGFloat x = [gesture translationInView:gesture.view].x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            !self.willChangeTrimmerFrame?:self.willChangeTrimmerFrame();
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat lx = self.maskView.frame.origin.x;
            lx += x;
           
            if (lx < 0) {
                lx = 0;
            } else if (lx + CGRectGetWidth(self.maskView.frame) > self.scrollView.contentSize.width) {
                lx = self.scrollView.contentSize.width - CGRectGetWidth(self.maskView.frame);
            }
            CGRect frame = self.maskView.frame;
            frame.origin.x = lx;
            /// 判断是否超出屏幕
            if (self.scrollView.contentOffset.x + 1 > lx) return;
            if (CGRectGetMaxX(frame) > self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds) - 1) return;
            
            self.maskView.frame = frame;
            [self updateDidChangeTrimmerFrame];
        }
            break;
        default:{
            !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)sliderPangesture:(UIPanGestureRecognizer *)gesture {
    CGFloat x = [gesture translationInView:gesture.view].x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            !self.willChangeTrimmerFrame?:self.willChangeTrimmerFrame();
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat lx = self.maskView.slider.frame.origin.x;
            lx += x;
           
            if (lx < 0) {
                lx = 0;
            } else if (lx + CGRectGetWidth(self.maskView.slider.frame) > CGRectGetWidth(self.maskView.frame)) {
                lx = CGRectGetWidth(self.maskView.frame) - CGRectGetWidth(self.maskView.slider.frame);
            }
            CGRect frame = self.maskView.slider.frame;
            frame.origin.x = lx;
            self.maskView.slider.frame = frame;
            [self updateDidChangeTrimmerFrame];
        }
            break;
        default:{
            !self.didEndChangeTrimmerFrame?:self.didEndChangeTrimmerFrame();
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

@end




