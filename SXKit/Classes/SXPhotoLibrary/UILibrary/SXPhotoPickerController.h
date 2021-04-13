//
//  SXPhotoPickerController.h
//  RACDemo
//
//  Created by taihe-imac-ios-01 on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface SXPhotoPickerController : UIViewController
+ (instancetype)defaultPickerController;
/// 最大选择数量 0为不限制
@property (nonatomic, assign) NSInteger maxSelectedCount;
@property (nonatomic, assign) PHAssetMediaType mediaType;

@property (nonatomic, copy) void(^selectCallBack)(NSArray <PHAsset *>*);
/// 指定选择一个数据(如果选中，则会回调selectCallBack )
@property (nonatomic, assign) NSInteger selectedIdx;
@end

NS_ASSUME_NONNULL_END
