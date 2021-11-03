//
//  SXPresentationOverlaySource.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPresentationOverlaySource : NSObject
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) UIBlurEffectStyle effectStyle;
///  default:YES
@property (nonatomic, assign) BOOL hideWhenTouchOverlay;
@end

NS_ASSUME_NONNULL_END
