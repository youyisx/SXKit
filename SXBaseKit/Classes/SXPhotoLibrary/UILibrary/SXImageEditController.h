//
//  FAImageEditController.h
//  FansApp
//
//  Created by vince_wang on 2021/3/12.
//  Copyright © 2021 legendry. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片编辑工具
NS_ASSUME_NONNULL_BEGIN

@interface SXImageEditController : UIViewController

@property (nonatomic, strong) UIImage *image;
/// 裁剪事件回调
@property (nonatomic, copy) void(^cutCallBack)(UIImage *cutImg, CGRect cutRect, SXImageEditController *vc);
@end

NS_ASSUME_NONNULL_END
