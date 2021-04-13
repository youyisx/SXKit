//
//  SXScreen.h
//  RACDemo
//
//  Created by taihe-imac-ios-01 on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#ifndef SXScreenDefine_h
#define SXScreenDefine_h

#import <UIKit/UIKit.h>
#define SXNavigationBarH    44.0
#define SXScale             [UIScreen mainScreen].scale

#define SXScreenW           [UIScreen mainScreen].bounds.size.width
#define SXScreenH           [UIScreen mainScreen].bounds.size.height
#define SXSafeAreaInsets    [UIApplication sharedApplication].windows.firstObject.safeAreaInsets

#define SXStatusBarHeight   SXSafeAreaInsets.top
#define SXSafeBottomHeight  SXSafeAreaInsets.bottom

#define SXImage(A) [UIImage imageNamed:A]
#define SXAdjustP(A) (SXScreenW > 320 ? A : (A * 0.8))

#endif /* SXScreenDefine_h */

