//
//  NSDate+SXDynamic.h
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SXDynamic)

- (NSDate *)sx_zeroDate;
- (NSDateComponents *)sx_dateComponents;

@end

NS_ASSUME_NONNULL_END
