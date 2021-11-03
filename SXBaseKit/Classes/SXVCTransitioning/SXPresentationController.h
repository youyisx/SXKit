//
//  SXPresentationController.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPresentationOverlaySource.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPresentationController : UIPresentationController

@property (nonatomic,strong) SXPresentationOverlaySource *overlaySource;

@end

NS_ASSUME_NONNULL_END
