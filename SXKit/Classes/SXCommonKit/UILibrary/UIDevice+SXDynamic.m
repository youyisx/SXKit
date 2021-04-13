//
//  UIDevice+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/3/30.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIDevice+SXDynamic.h"

@implementation UIDevice (SXDynamic)

+ (BOOL)sx_rotate:(UIDeviceOrientation)orientation {
    if ([UIDevice currentDevice].orientation == orientation) {
        [UIViewController attemptRotationToDeviceOrientation];
        return NO;
    }
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    return YES;
}

@end
