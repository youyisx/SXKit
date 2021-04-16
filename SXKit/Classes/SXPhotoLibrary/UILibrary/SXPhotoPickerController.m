//
//  SXPhotoPickerController.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPhotoPickerController.h"
#import "SXPhotoHelper.h"
#import <Masonry/Masonry.h>
#import "UIImageView+SXPHAsset.h"
#import <SXKit/SXScreenDefine.h>
#import <SXKit/SXHudHeader.h>
#define SXAssetSortKey @"k_sxassetsort_0"
#import <objc/runtime.h>
#import <SXKit/SXCommon.h>
@interface PHAsset(SXKitSort)
@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, assign) NSInteger selectedSort;
@end
@implementation PHAsset(SXKitSort)
@dynamic selectedSort;

- (BOOL)isSelected {
    return self.selectedSort > 0;
}

- (void)setSelectedSort:(NSInteger)selectedSort {
    NSInteger oldValue = self.selectedSort;
    if (oldValue == selectedSort) return;
    [self willChangeValueForKey:@"selectedSort"];
    objc_setAssociatedObject(self, SXAssetSortKey, @(selectedSort), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"selectedSort"];
    if ((oldValue > 0 && selectedSort <= 0) || (oldValue <= 0 && selectedSort > 0)) {
        [self willChangeValueForKey:@"isSelected"];
        [self didChangeValueForKey:@"isSelected"];
    }
}

- (NSInteger)selectedSort {
    return [objc_getAssociatedObject(self, SXAssetSortKey) integerValue];
}

@end

@interface SXPHAssetCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *selectedFrameView;
@end

@implementation SXPHAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.selectedFrameView = [UIView new];
    self.selectedFrameView.backgroundColor = [UIColor clearColor];
    self.selectedFrameView.layer.borderWidth = 2;
    self.selectedFrameView.layer.borderColor = SXColorHex(@"#A876FF").CGColor;
    self.selectedFrameView.layer.cornerRadius = 10;
 
    self.imgView = [UIImageView new];
    self.imgView.layer.cornerRadius = 10;
    self.imgView.tag = 10;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = true;
    
    [self.contentView addSubview:self.selectedFrameView];
    [self.selectedFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.selectedFrameView.hidden = true;
}

- (void)sx_updateWithModel:(id)model {
    PHAsset *asset = model;
    if (![asset isKindOfClass:[PHAsset class]]) return;
    self.imgView.sx_asset = asset;
    @weakify(self)
    [[[RACObserve(asset, isSelected) distinctUntilChanged] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.selectedFrameView.hidden = [x boolValue] == NO;
    }];
}


@end

@interface SXPhotoPickerController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SXPhotoHelper *helper;
@property (nonatomic, strong) NSMutableDictionary <NSString *,PHAsset *>*selectedAssets;
@end

@implementation SXPhotoPickerController
+ (instancetype)defaultPickerController {
    SXPhotoPickerController *picker = [[SXPhotoPickerController alloc] initWithNibName:nil bundle:nil];
    return picker;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.selectedIdx = -1;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    @weakify(self)
    [[SXPhotoHelper phPhotoLibrayAuthorization] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        [self loadHelp];
    }];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    CGFloat w_ = (SXScreenW - 30 - layout.sectionInset.left - layout.sectionInset.right) / 4.0;
    w_ = floor(w_);
    layout.itemSize = CGSizeMake(w_, w_);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
}


- (void)loadHelp {
    self.helper = [[SXPhotoHelper alloc] initWithMediaType:self.mediaType];
    self.helper.currentAlbum = nil;
    @weakify(self)
    [[RACObserve(self.helper, currentAssets) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.selectedIdx >= 0 &&
            self.helper.currentAssets.count > self.selectedIdx &&
            self.selectedAssets.count == 0) {
            /// 默认选中一个先
            [self _selectedAsset:[self.helper.currentAssets objectAtIndex:self.selectedIdx]];
            self.selectedIdx = -1;
        }
        [self.collectionView reloadData];
    }];
    
}

#pragma mark --- collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.helper.currentAssets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView sx_dequeueReusableCellWithIdentifier:SXPHAssetCell.sx_defaultIdentifier indexPath:indexPath];
    PHAsset *asset = [self.helper.currentAssets objectAtIndex:indexPath.item];
    [self _checkAsstSelectStatus:asset];
    [cell sx_updateWithModel:asset];
    return cell;
}

- (void)_checkAsstSelectStatus:(PHAsset *)asset {
    NSString *key_ = asset.localIdentifier;
    if (key_.length == 0) return;
    PHAsset *selectAsset = self.selectedAssets[key_];
    if (selectAsset == nil) return;
    asset.selectedSort = selectAsset.selectedSort;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [self.helper.currentAssets objectAtIndex:indexPath.item];
    [self _selectedAsset:asset];
}

- (void)_selectedAsset:(PHAsset *)asset {
    NSString *key_ = asset.localIdentifier;
    if (key_.length == 0) return;
    
    if (self.selectedAssets == nil) self.selectedAssets = [NSMutableDictionary dictionary];
    
    if (self.maxSelectedCount <= 1) { // 单选
        
        if ([self.selectedAssets sx_containsObjectForKey:key_]) return;
        [self.selectedAssets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, PHAsset * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.selectedSort = 0;
        }];
        [self.selectedAssets removeAllObjects];
        self.selectedAssets[key_] = asset;
        asset.selectedSort = self.selectedAssets.count;
    } else { // 多选
        PHAsset *oldValue = self.selectedAssets[key_];
        if (oldValue) { // 取消选中
            NSInteger oldSort = oldValue.selectedSort;
            oldValue.selectedSort = 0;
            self.selectedAssets[key_] = nil;
            [self.selectedAssets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, PHAsset * _Nonnull obj, BOOL * _Nonnull stop) {
                NSInteger sort_ = obj.selectedSort;
                if (sort_ > oldSort) obj.selectedSort = (sort_ - 1);
            }];
        } else if (self.selectedAssets.count >= self.maxSelectedCount) {
            SXShowTips([NSString stringWithFormat:@"最多可选%@个",@(self.maxSelectedCount)]);
        } else {
            self.selectedAssets[key_] = asset;
            asset.selectedSort = self.selectedAssets.count;
        }
    }
    NSArray <PHAsset *>*result = [self.selectedAssets allValues];
    result = [result sortedArrayUsingComparator:^NSComparisonResult(PHAsset * obj1, PHAsset * obj2) {
        return obj1.selectedSort < obj2.selectedSort;
    }];
    !self.selectCallBack?:self.selectCallBack(result);
}

@end



