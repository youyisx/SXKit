//
//  UIView+SXTransitionPrivate.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXTransitionPrivate)
@property (nonatomic, strong, nullable) UIView *sx_transitionOverlayView;
@end

NS_ASSUME_NONNULL_END
