//
//  UITableView+SXDynamic.h
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SXDynamic)

- (UITableViewCell *)sx_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                indexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)sx_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                 cellName:(NSString *)cell
                                                indexPath:(NSIndexPath *)indexPath ;

- (BOOL)sx_scrollToCell:(UITableViewCell *)cell
       atScrollPosition:(UITableViewScrollPosition)scrollPosition
               animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
