//
//  NSString+SXDate.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SXDate)

- (NSDate *)sx_dateWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
