//
//  UITableView+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/2.
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
@end

NS_ASSUME_NONNULL_END
