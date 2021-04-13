//
//  UITableView+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UITableView+SXDynamic.h"
#import "UIView+SXDynamic.h"
#import "NSObject+SXDynamic.h"
@implementation UITableView (SXDynamic)

- (UITableViewCell *)sx_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                     indexPath:(NSIndexPath *)indexPath{
    NSString *cellName = identifier;
    if ([cellName hasSuffix:SXNibIdentifierSuffix]) {
        NSInteger to = cellName.length - SXNibIdentifierSuffix.length;
        cellName = [cellName substringToIndex:to];
    }
    return [self sx_dequeueReusableCellWithIdentifier:identifier cellName:cellName indexPath:indexPath];
}


- (UITableViewCell *)sx_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                      cellName:(NSString *)cell
                                                     indexPath:(NSIndexPath *)indexPath {
    NSString *key_ = [NSString stringWithFormat:@"register_%@",identifier];
    if (![[self sx_objectForKey:key_] boolValue]) {
        if ([identifier hasSuffix:SXNibIdentifierSuffix]) {
            /// 通过NIB注册
            [self registerNib:[NSClassFromString(cell) sx_defaultNib] forCellReuseIdentifier:identifier];
        } else {
            [self registerClass:NSClassFromString(cell) forCellReuseIdentifier:identifier];
        }
        [self sx_setObject:@(true) forKey:key_];
      }
      UITableViewCell *result = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
      return result ? result : [UITableViewCell new];
}


@end
