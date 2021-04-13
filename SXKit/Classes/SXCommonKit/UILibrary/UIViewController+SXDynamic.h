//
//  UIViewController+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SXDynamic)

- (void)sx_goBack;

- (UIView *)sx_appBottomBar:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
