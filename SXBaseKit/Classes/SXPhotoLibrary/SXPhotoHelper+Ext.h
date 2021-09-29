//
//  SXPhotoHelper+Ext.h
//  VSocial
//
//  Created by vince_wang on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import <SXBaseKit/SXPhotoHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPhotoHelper (Ext)

+ (void)openSystemPhotoLibaryWithEdit:(BOOL)edit complete:(void(^)(UIImage *img))completed;

@end

NS_ASSUME_NONNULL_END
