//
//  SXScribbleView.m
//  SXScribbleDemo
//
//  Created by taihe-imac-ios-01 on 2021/9/22.
//

#import "SXScribbleView.h"


@interface SXScribbleView()

@property (nonatomic, strong) UIBezierPath * path;
@property (nonatomic, strong) NSMutableArray <UIBezierPath *>* pathArray;

@property (nonatomic, strong) CAShapeLayer   * shapeLayer;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>* layerArray;

@property (nonatomic, strong) CAShapeLayer   * rectLayer;

@end

@implementation SXScribbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    _autoDrawRectangles = NO;
    _lineWidth = 20;
    _lineColor = UIColor.redColor;
    _rectangleStrokeColor = UIColor.blueColor;
    _rectangleStrokeWidth = 1;
    
    _pathArray = [NSMutableArray array];
    _layerArray = [NSMutableArray array];
}
/// 撤销
- (void)revoke {
    if (_layerArray.count == 0) return;
    [_layerArray.lastObject removeFromSuperlayer];
    [_layerArray removeLastObject];
    [_pathArray removeLastObject];
    if (_rectLayer || _autoDrawRectangles) [self drawRectangles];
}
/// 清屏
- (void)clear {
    [_rectLayer removeFromSuperlayer];
    
    _rectLayer = nil;
    [_layerArray enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [_layerArray removeAllObjects];
    [_pathArray removeAllObjects];
}
/// 绘制涂抹的矩形区域
- (void)drawRectangles {
    [_rectLayer removeFromSuperlayer];
    _rectLayer = nil;
    NSArray <NSValue *>*rectangles = [self currentRectangles];
    if (rectangles.count == 0) return;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = _rectangleStrokeColor.CGColor;
    layer.lineWidth = _rectangleStrokeWidth;
    UIBezierPath *path_ = [UIBezierPath bezierPath];
    [rectangles enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [path_ appendPath:[UIBezierPath bezierPathWithRect:obj.CGRectValue]];
    }];
    layer.path = path_.CGPath;
    [self.layer addSublayer:layer];
    _rectLayer = layer;
}

///  获取涂抹的矩形区域
- (NSArray <NSValue *>*)currentRectangles {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_pathArray.count];
    CGFloat offset = _lineWidth * 0.5;
    CGFloat maxWidth = CGRectGetWidth(self.bounds);
    CGFloat maxHeight = CGRectGetHeight(self.bounds);
    [_pathArray enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.bounds;
        rect.origin.x -= offset;
        rect.origin.y -= offset;
        rect.size.width += _lineWidth;
        rect.size.height += _lineWidth;
        if (rect.origin.x < 0) rect.origin.x = 0;
        if (rect.origin.y < 0) rect.origin.y = 0;
        if (CGRectGetMaxX(rect) > maxWidth) rect.size.width = maxWidth - rect.origin.x;
        if (CGRectGetMaxY(rect) > maxHeight) rect.size.height = maxHeight - rect.origin.y;
        [array addObject:[NSValue valueWithCGRect:rect]];
    }];
    return array;
}

#pragma mark -- set & get

- (void)setAutoDrawRectangles:(BOOL)autoDrawRectangles {
    _autoDrawRectangles = autoDrawRectangles;
    if (autoDrawRectangles) {
        [self drawRectangles];
    } else if(_rectLayer) {
        [_rectLayer removeFromSuperlayer];
        _rectLayer = nil;
    }
}

#pragma mark --- touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, p)) {
        _path = nil;
        _shapeLayer = nil;
        return;
    }
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:p];
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.lineCap = kCALineCapRound;
    slayer.lineJoin = kCALineJoinRound;
    slayer.lineWidth = _lineWidth;
    slayer.strokeColor = _lineColor.CGColor;
    slayer.fillColor = UIColor.clearColor.CGColor;
    slayer.path = _path.CGPath;
    [self.layer addSublayer:slayer];
    _shapeLayer = slayer;
    
    [_layerArray addObject:slayer];
    [_pathArray addObject:_path];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, p)) return;
    [_path addLineToPoint:p];
    _shapeLayer.path = _path.CGPath;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, p)) return;
    [_path addLineToPoint:p];
    _shapeLayer.path = _path.CGPath;
    [self _touchEnd];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, p)) return;
    [_path addLineToPoint:p];
    _shapeLayer.path = _path.CGPath;
    [self _touchEnd];
}

- (void)_touchEnd {
    _path = nil;
    _shapeLayer = nil;
    if (_autoDrawRectangles) [self drawRectangles];
}



@end

