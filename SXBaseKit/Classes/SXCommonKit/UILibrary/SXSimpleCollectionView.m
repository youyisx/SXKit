//
//  SXSimpleCollectionView.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/5/7.
//

#import "SXSimpleCollectionView.h"
#import <UIView+SXDynamic.h>
#define k_simple_CellIdentifier @"k_simple_CellIdentifier"
typedef NS_ENUM(NSInteger, SXSimpleScrollDirection) {
    SXSimpleScrollUnknow,
    SXSimpleScrollLeft,
    SXSimpleScrollRight,
    SXSimpleScrollUp,
    SXSimpleScrollDown,
};

@interface SXSimpleCollectionView()
@property (nonatomic, assign) CGPoint moveP;
@property (nonatomic,assign) SXSimpleScrollDirection simpleDirection;
@end
@implementation SXSimpleCollectionView

+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout {
    return [self simpleWithLayout:layout cell:nil];
}

+ (instancetype)simpleWithLayout:(UICollectionViewFlowLayout *)layout
                            cell:(NSString *_Nullable)cell {
    SXSimpleCollectionView *collectionView = [[[self class] alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
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
#pragma mark --- scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self || !self.sx_pagingEnabled) return;
    self.moveP = scrollView.contentOffset;
    self.simpleDirection = SXSimpleScrollUnknow;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self || !self.sx_pagingEnabled) return;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (![layout isKindOfClass:[UICollectionViewFlowLayout class]]) return;
    CGPoint p = scrollView.contentOffset;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (p.x > self.moveP.x) {
            self.simpleDirection = SXSimpleScrollRight;
        } else if(p.x < self.moveP.x) {
            self.simpleDirection = SXSimpleScrollLeft;
        }
    } else {
        if (p.y > self.moveP.y) {
            self.simpleDirection = SXSimpleScrollDown;
        } else if(p.y < self.moveP.y) {
            self.simpleDirection = SXSimpleScrollUp;
        }
    }
    self.moveP = p;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!self.sx_pagingEnabled || scrollView != self) return;
    if (self.simpleDirection == SXSimpleScrollUnknow) {
        return;
    }
    
    CGPoint point = scrollView.contentOffset;
    if (self.simpleDirection == SXSimpleScrollRight) {
        point.x += CGRectGetWidth(scrollView.bounds);
    } else if (self.simpleDirection == SXSimpleScrollDown) {
        point.y += CGRectGetHeight(scrollView.bounds);
    }
    BOOL isHorizontal = (self.simpleDirection == SXSimpleScrollLeft || self.simpleDirection == SXSimpleScrollRight);
    
    NSArray <UICollectionViewCell *>*cells = [self visibleCells];
    UICollectionViewCell *centerCell = nil;
    CGFloat distance = 0;
    for (UICollectionViewCell *cell in cells) {
        if (isHorizontal) {
            CGFloat px = point.x;
            CGFloat cellX = cell.frame.origin.x;
            CGFloat cellX_end = cell.frame.size.width + cellX;
            if (px >= cellX && px <= cellX_end) {
                centerCell = cell;
                break;
            } else {
                if (self.simpleDirection == SXSimpleScrollRight) {
                    CGFloat temp = px - cellX;
                    if (temp < 0) continue;
                    if (distance == 0 || temp < distance) {
                        distance = temp;
                        centerCell = cell;
                    }
                } else {
                    CGFloat temp = cellX - px;
                    if (temp < 0) continue;
                    if (distance == 0 || temp < distance) {
                        distance = temp;
                        centerCell = cell;
                    }
                }
            }
        } else {
            CGFloat py = point.y;
            CGFloat cellY = cell.frame.origin.y;
            CGFloat cellY_end = cell.frame.size.height + cellY;
            if (py >= cellY && py <= cellY_end) {
                centerCell = cell;
                break;
            } else {
                if (self.simpleDirection == SXSimpleScrollDown) {
                    CGFloat temp = py - cellY;
                    if (temp < 0) continue;
                    if (distance == 0 || temp < distance) {
                        distance = temp;
                        centerCell = cell;
                    }
                } else {
                    CGFloat temp = cellY - py;
                    if (temp < 0) continue;
                    if (distance == 0 || temp < distance) {
                        distance = temp;
                        centerCell = cell;
                    }
                }
            }
        }
    }
    
    
    if (!centerCell) return;
    CGRect frame = centerCell.frame;
    if (isHorizontal) {
        CGFloat edge = (CGRectGetWidth(self.bounds) - frame.size.width) * 0.5;
        (*targetContentOffset).x = frame.origin.x - edge;
    } else {
        CGFloat edge = (CGRectGetHeight(self.bounds) - frame.size.height) * 0.5;
        (*targetContentOffset).y = frame.origin.y - edge;
    }
}

@end
