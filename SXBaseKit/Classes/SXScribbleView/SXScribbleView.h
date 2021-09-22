//
//  SXScribbleView.h
//  SXScribbleDemo
//
//  Created by taihe-imac-ios-01 on 2021/9/22.
//

#import <UIKit/UIKit.h>
/// 涂抹控件
NS_ASSUME_NONNULL_BEGIN

@interface SXScribbleView : UIView
/// 涂抹线条宽度 默认20
@property (nonatomic, assign)   CGFloat lineWidth;
/// 涂抹线条颜色 默认 红色
@property (nonatomic, copy)     UIColor *lineColor;
/// 撤销上一次涂抹
- (void)revoke ;
/// 清除所有
- (void)clear;

/// 生成的区域矩形边框颜色 默认为 1
@property (nonatomic, copy)     UIColor *rectangleStrokeColor;
/// 生成的区域矩形边框线条宽 默认为 蓝色
@property (nonatomic, assign)   CGFloat rectangleStrokeWidth;
/// 自动根据每次的涂抹区域绘制矩形 默认为false 
@property (nonatomic, assign)   BOOL    autoDrawRectangles;
/// 绘制涂抹的矩形区域
- (void)drawRectangles;
///  获取涂抹的矩形区域
- (NSArray <NSValue *>*)currentRectangles;
@end


NS_ASSUME_NONNULL_END
