//
//  SXPresentationOverlaySource.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXPresentationOverlaySource.h"

@implementation SXPresentationOverlaySource

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    self.alpha = 1;
    self.color = [UIColor colorWithWhite:0 alpha:0.4];
    self.effectStyle = -1;
    self.hideWhenTouchOverlay = YES;
}

@end
