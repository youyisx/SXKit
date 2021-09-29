//
//  SXPhotoHelper.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPhotoHelper : NSObject
@property (nonatomic, assign, readonly) PHAssetMediaType mediaType;
/// 相册目录
@property (nonatomic, strong, readonly) NSArray <PHAssetCollection *>*albums;
/// 当前相册 (修改该属性后，currentAssets将自动更改)
@property (nonatomic, strong, nullable) PHAssetCollection *currentAlbum;
/// 当前相册的资源（如果currentAlbum 为nil，则返回全部资源）
@property (nonatomic, strong, readonly) PHFetchResult *currentAssets;

- (instancetype)initWithMediaType:(PHAssetMediaType)mediaType;

@end

@interface SXPhotoHelper(Append)
/// 获取相册目录
+ (NSArray <PHAssetCollection *>*)phAssetCollections;
/// 获取相册资源
+ (PHFetchResult *)phAssetsFrom:(nullable PHAssetCollection *)album mediaType:(PHAssetMediaType)type;
/// 相册授权
+ (RACSignal <NSNumber *>*)phPhotoLibrayAuthorization;

+ (void)saveLocalVideoWithAsset:(PHAsset *)asset result:(void(^)(NSString *path, NSString *key))result;
+ (RACSignal <NSString *>*)saveLocalVideoWithAsset:(PHAsset *)asset;
@end
NS_ASSUME_NONNULL_END
