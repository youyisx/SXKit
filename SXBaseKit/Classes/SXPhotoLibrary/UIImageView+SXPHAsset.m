//
//  UIImageView+SXPHAsset.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIImageView+SXPHAsset.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>
static void *k_sx_phImageManager    = &k_sx_phImageManager;
static void *k_sx_asset             = &k_sx_asset;
static void *k_sx_loadManager       = &k_sx_loadManager;
static void *k_sx_requestID         = &k_sx_requestID;
static void *k_sx_layoutDisposable  = &k_sx_layoutDisposable;
@implementation UIImageView (SXPHAsset)
@dynamic sx_phImageManager;

- (PHImageManager *)sx_phImageManager {
    return objc_getAssociatedObject(self, k_sx_phImageManager);
}

- (void)setSx_phImageManager:(PHImageManager *)sx_phImageManager {
    objc_setAssociatedObject(self, k_sx_phImageManager, sx_phImageManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
static PHImageManager *imageManager = nil;
+ (PHImageManager *)sx_phImageManager {
    if (imageManager == nil) imageManager = [PHImageManager defaultManager];
    return imageManager;
}

+ (void)setSx_phImageManager:(PHImageManager *)sx_phImageManager {
    imageManager = sx_phImageManager;
}

- (PHAsset *)sx_asset {
    return objc_getAssociatedObject(self, k_sx_asset);
}

- (void)sx_updateAsset:(PHAsset *)asset {
    [self sx_updateAsset:asset placeHolder:nil load:nil];
}

- (void)sx_updateAsset:(PHAsset *)asset placeHolder:(UIImage *)placeHolder {
    [self sx_updateAsset:asset placeHolder:placeHolder load:nil];
}

- (void)sx_updateAsset:(PHAsset *)asset placeHolder:(UIImage *)placeHolder load:(SXPHAssetLoadBlock)load{
    [self _sx_cancelRequest];
    [self _sx_clearRequestElement];
    self.image = placeHolder;
    objc_setAssociatedObject(self, k_sx_asset, asset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (asset == nil) {
        !load?:load(self,NO);
        return;
    }
    
    CGFloat w_ = ceil(self.frame.size.width);
    CGFloat h_ = ceil(self.frame.size.height);
    CGFloat scale_ =  [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(w_ *scale_, h_ *scale_);
    
    @weakify(self)
    RACDisposable *layoutDisposable =
    [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        CGSize changeSize = self.frame.size;
        if (ceil(changeSize.width) == w_ && ceil(changeSize.height) == h_) return;
        [self sx_updateAsset:asset placeHolder:self.image load:load];
    }];
    objc_setAssociatedObject(self, k_sx_layoutDisposable, layoutDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (w_ <= 0 || h_ <= 0) {
        !load?:load(self,NO);
        return;
    }
    
    PHImageManager *manager = self.sx_phImageManager;
    if (manager == nil) manager = [[self class] sx_phImageManager];
   
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = false;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = true;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    !load?:load(self,YES);
    
    PHImageRequestID requestID =
    [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        @strongify(self)
        if (result) self.image = result;
        [self _sx_clearRequestElement];
        !load?:load(self,NO);
    }];
    
    objc_setAssociatedObject(self, k_sx_requestID, @(requestID), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, k_sx_loadManager, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_sx_cancelRequest {
    RACDisposable *layoutDisposable  = objc_getAssociatedObject(self, k_sx_layoutDisposable);
    [layoutDisposable dispose];
    objc_setAssociatedObject(self, k_sx_layoutDisposable, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    PHImageManager *manager = objc_getAssociatedObject(self, k_sx_loadManager);
    NSNumber *requestID = objc_getAssociatedObject(self, k_sx_requestID);
    [manager cancelImageRequest:[requestID intValue]];
}

- (void)_sx_clearRequestElement {
    objc_setAssociatedObject(self, k_sx_loadManager, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, k_sx_requestID, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
