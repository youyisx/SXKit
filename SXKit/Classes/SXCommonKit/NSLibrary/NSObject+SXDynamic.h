//
//  NSObject+SXDynamic.h
//  RACDemo
//
//  Created by taihe-imac-ios-01 on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SXDynamic)

- (void)sx_setObject:(nullable id)object forKey:(NSString *)key;
- (id)sx_objectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
