//
//  NSDictionary+SXDynamic.h
//  SXKit
//
//  Created by vince_wang on 2021/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SXDynamic)
- (BOOL)sx_containsObjectForKey:(id)key;
@end

NS_ASSUME_NONNULL_END
