//
//  UIImageView+SXPHAsset.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIImageView+SXPHAsset.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <SXKit/SXCommon.h>
#define k_phImageManager @"k_phImageManager"
#define k_requestID @"k_requestID"
#define k_asset @"k_asset"
#import <Masonry/Masonry.h>
@implementation UIImageView (SXPHAsset)

- (PHImageManager *)phImageManager {
    PHImageManager *result = [self sx_objectForKey:k_phImageManager];
    if (result == nil) {
        result = [PHImageManager defaultManager];
        [self sx_setObject:result forKey:k_phImageManager];
    }
    return result;
}

- (void)setSx_asset:(PHAsset *)sx_asset {
    [self sx_updateAsset:sx_asset];
    [self sx_setObject:sx_asset forKey:k_asset];
    if (sx_asset == nil) return;
    if ([self sizeChangeHandler] != nil) return;
    @weakify(self)
    self.sizeChangeHandler = ^(CGSize size, UIView * _Nonnull target) {
      @strongify(self)
        [self sx_updateAsset:self.sx_asset];
    };
}

- (PHAsset *)sx_asset {
    return [self sx_objectForKey:k_asset];
}

- (void)sx_updateAsset:(nullable PHAsset *)asset {
    self.image = nil;
    PHImageRequestID cancelID = [[self sx_objectForKey:k_requestID] intValue];
    [[self phImageManager] cancelImageRequest:cancelID];
    if (![asset isKindOfClass:[PHAsset class]]) return;
    CGSize size = self.bounds.size;
    if (CGSizeEqualToSize(CGSizeZero, size)) return;
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = false;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = true;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;

    size.width = size.width * [UIScreen mainScreen].scale;
    size.height = size.height * [UIScreen mainScreen].scale;
    UIActivityIndicatorView *loadingView = [self sx_objectForKey:@"k_loading"];
    if (loadingView == nil) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = true;
        [self addSubview:loadingView];
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        [self sx_setObject:loadingView forKey:@"k_loading"];
    }
    [loadingView startAnimating];
    @weakify(self)
    PHImageRequestID requestID =
    [[self phImageManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit
                                        options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        @strongify(self)
        self.image = result;
        [loadingView stopAnimating];
    }];
    [self sx_setObject:@(requestID) forKey:k_requestID];
//    NSInteger duration = asset.duration;
//    UILabel *label = [self sx_objectForKey:@"k_label"];
//    if (duration > 0) {
//        if (label == nil) {
//            label = [UILabel new];
//            label.font = [UIFont systemFontOfSize:11];
//            label.textColor = UIColor.whiteColor;
//            [self addSubview:label];
//            [self sx_setObject:label forKey:@"k_label"];
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.trailing.mas_equalTo(0);
//            }];
//        }
//        NSInteger minute = duration/60;
//        NSInteger second = duration%60;
//        label.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
//        label.hidden = NO;
//    } else {
//        label.hidden = YES;
//    }
    
    
}

@end
