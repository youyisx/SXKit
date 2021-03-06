//
//  SXScreen.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#ifndef SXCommonDefines_h
#define SXCommonDefines_h

#import <UIKit/UIKit.h>
#define SXNavigationBarH    44.0
#define SXScale             [UIScreen mainScreen].scale

#define SXScreenW           [UIScreen mainScreen].bounds.size.width
#define SXScreenH           [UIScreen mainScreen].bounds.size.height

NS_INLINE UIEdgeInsets _SXSafeAreaInsets() {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].windows.firstObject.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
    }
}
#define SXSafeAreaInsets    _SXSafeAreaInsets()
#define SXStatusBarHeight   SXSafeAreaInsets.top
#define SXSafeBottomHeight  SXSafeAreaInsets.bottom

#define SXImage(A) [UIImage imageNamed:A]
#define SXAdjustP(A) (SXScreenW > 320 ? A : (A * 0.8))


NS_INLINE BOOL sx_sizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

NS_INLINE BOOL sx_sizeIsNan(CGSize size) {
    return isnan(size.width) || isnan(size.height);
}

NS_INLINE BOOL sx_sizeIsInf(CGSize size) {
    return isinf(size.width) || isinf(size.height);
}

#endif /* SXCommonDefines_h */

