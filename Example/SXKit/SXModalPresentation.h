//
//  SXModalPresentation.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/5/8.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SXModelPresentationVal : NSObject
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, assign) CGSize sliderSize;

@property (nonatomic, assign) UIEdgeInsets contentEdge;
@property (nonatomic, strong) UIColor *contentBackColor;
@property (nonatomic, assign) CGFloat topCornerRadius;

@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) BOOL hidenWhenTouchMask;

@property (nonatomic, assign) CGFloat heightScale;

+ (instancetype)defaultVal;
@property (nonatomic, copy) dispatch_block_t didHideBlock;
@end



@interface SXModalPresentation : NSObject

+ (void)presentationWithView:(UIView *)view val:(SXModelPresentationVal * _Nullable)val completed:(void(^__nullable)(BOOL success))completed;

+ (void)presentationWithViewController:(UIViewController *)vc val:(SXModelPresentationVal *_Nullable)val completed:(void(^__nullable)(BOOL success))completed;

@end

NS_ASSUME_NONNULL_END
