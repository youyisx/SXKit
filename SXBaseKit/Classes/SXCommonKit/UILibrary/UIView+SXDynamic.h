//
//  UIView+SXDynamic.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#define SXNibIdentifierSuffix @"_nib"
typedef void(^SXSizeChangeHandler)(CGSize size, UIView * _Nonnull target);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXDynamic)

@property (nonatomic, copy, nullable) SXSizeChangeHandler sizeChangeHandler ;
/// size 发生变化后 会触发该信号
- (RACSignal <UIView *>*)sx_sizeChangeSignal;
/// 公共的根据数据模型更新视图的函数，由实例自身实现具体逻辑
- (void)sx_updateWithModel:(nullable id)model;

+ (UINib *)sx_defaultNib;

+ (instancetype)sx_defaultNibView;

+ (NSString *)sx_defaultIdentifier;

+ (NSString *)sx_defaultNibIdentifier;

- (void)sx_tapAction:(dispatch_block_t)block;
- (UITapGestureRecognizer *)sx_tapGesture;

+ (UIView * (^)(UIColor *_Nullable, CGRect))sx_view1;
+ (UIView * (^)(UIColor *_Nullable))sx_view;
- (UIView * (^)(UIColor *_Nullable))sx_backColor;
- (UIView * (^)(CGFloat))sx_radius;
- (UIView * (^)(UIColor *color, CGFloat width))sx_border;
- (UIView * (^)(CGRect))sx_frame;
/// 添加一个宽度约束
- (void)sx_addWidthAttributeLayout:(CGFloat)width;
/// 添加一个高度约束
- (void)sx_addHeightAttributeLayout:(CGFloat)width;
/// view 转image
- (UIImage *)sx_snapshotLayerImage;

- (void)sx_addBottomLine:(CGFloat)height color:(UIColor *)color edge:(UIEdgeInsets)edge;
- (void)sx_removeBottomLine;
@end

NS_ASSUME_NONNULL_END
