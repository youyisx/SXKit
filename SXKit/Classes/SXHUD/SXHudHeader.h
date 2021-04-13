//
//  SXHudHeader.h
//  VSocial
//
//  Created by vince_wang on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#ifndef SXHudHeader_h
#define SXHudHeader_h
#import "UIView+SXHud.h"
#import "SXNavigationHeader.h"
NS_INLINE void SXShowTips(NSString *tips) {
    [SXRootWindow() sx_showTips:tips];
}

NS_INLINE void SXShowHud() {
    [SXRootWindow() sx_showHud];
}

NS_INLINE void SXHideHud() {
    [SXRootWindow() sx_hideHud];
}

#endif /* SXHudHeader_h */
