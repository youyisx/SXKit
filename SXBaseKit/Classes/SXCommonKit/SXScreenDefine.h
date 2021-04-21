//
//  SXScreen.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#ifndef SXScreenDefine_h
#define SXScreenDefine_h

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

#endif /* SXScreenDefine_h */

