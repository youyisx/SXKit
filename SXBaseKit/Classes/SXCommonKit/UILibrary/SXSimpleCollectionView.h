//
//  SXSimpleCollectionView.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/5/7.
//

#import <UIKit/UIKit.h>
/// 这是一个简易版的collectionview ，内部实现代理，外部直接调用就行了
NS_ASSUME_NONNULL_BEGIN

@interface SXSimpleCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout;
+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout
                            cell:(NSString *_Nullable )cell;

@property (nonatomic, copy) NSArray *sources;
@property (nonatomic, copy) UICollectionViewCell *(^cellForItemAt)(SXSimpleCollectionView *collectionview, NSIndexPath *indexPath, id model) ;
@property (nonatomic, copy) void(^didSelectItem)(SXSimpleCollectionView *collectionView, NSIndexPath *indexPath, id model);
@end


NS_ASSUME_NONNULL_END
