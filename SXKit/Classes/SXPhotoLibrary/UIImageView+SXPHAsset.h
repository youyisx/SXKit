//
//  UIImageView+SXPHAsset.h
//  RACDemo
//
//  Created by taihe-imac-ios-01 on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SXPHAsset)
@property (nonatomic, strong, nullable) PHAsset * sx_asset;

@end

NS_ASSUME_NONNULL_END
