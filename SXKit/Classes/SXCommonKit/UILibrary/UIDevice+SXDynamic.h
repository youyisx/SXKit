//
//  UIDevice+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/3/30.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (SXDynamic)

+ (BOOL)sx_rotate:(UIDeviceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
