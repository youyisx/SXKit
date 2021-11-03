//
//  SXAppDelegate.h
//  SXKit
//
//  Created by vince_wang on 04/09/2021.
//  Copyright (c) 2021 vince_wang. All rights reserved.
//

@import UIKit;

@interface SXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/// 播放器方向
@property (nonatomic, assign) UIDeviceOrientation vodPlayerOrientation;

@end
