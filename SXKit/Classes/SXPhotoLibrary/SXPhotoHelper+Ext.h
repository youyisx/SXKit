//
//  SXPhotoHelper+Ext.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPhotoHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXPhotoHelper (Ext)

+ (void)openSystemPhotoLibaryWithEdit:(BOOL)edit complete:(void(^)(UIImage *img))completed;

@end

NS_ASSUME_NONNULL_END
