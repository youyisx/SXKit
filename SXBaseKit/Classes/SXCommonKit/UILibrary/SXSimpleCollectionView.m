//
//  SXSimpleCollectionView.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/5/7.
//

#import "SXSimpleCollectionView.h"
#import <UIView+SXDynamic.h>
#define k_simple_CellIdentifier @"k_simple_CellIdentifier"
@implementation SXSimpleCollectionView

+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout {
    return [self simpleWithLayout:layout cell:nil];
}

+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout
                            cell:(NSString *_Nullable)cell {
    SXSimpleCollectionView *collectionView = [[[self class] alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    if (cell.length) {
        Class c = NSClassFromString(cell);
        if (c) [collectionView registerClass:c forCellWithReuseIdentifier:k_simple_CellIdentifier];
    }
    return collectionView;
}

- (void)setSources:(NSArray *)sources {
    _sources = [sources copy];
    [self reloadData];
}

#pragma mark --- collectionview

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellForItemAt) return self.cellForItemAt(self,indexPath, self.sources[indexPath.item]);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:k_simple_CellIdentifier forIndexPath:indexPath];
    [cell sx_updateWithModel:self.sources[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sources.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    !self.didSelectItem?:self.didSelectItem(self,indexPath,self.sources[indexPath.item]);
}

@end
