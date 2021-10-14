//
//  UIImageView+SXPHAsset.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SXPHAssetLoadBlock)(UIImageView *contentView, BOOL loading) ;

@interface UIImageView (SXPHAsset)

@property (nonatomic, strong) PHImageManager *sx_phImageManager;
@property (nonatomic, strong, class) PHImageManager *sx_phImageManager;

- (void)sx_updateAsset:(PHAsset *_Nullable)asset;
- (void)sx_updateAsset:(PHAsset *_Nullable)asset placeHolder:(UIImage *_Nullable)placeHolder;
- (void)sx_updateAsset:(PHAsset *_Nullable)asset placeHolder:(UIImage *_Nullable)placeHolder load:(SXPHAssetLoadBlock _Nullable)load;
- (PHAsset *_Nullable)sx_asset;
@end

NS_ASSUME_NONNULL_END
