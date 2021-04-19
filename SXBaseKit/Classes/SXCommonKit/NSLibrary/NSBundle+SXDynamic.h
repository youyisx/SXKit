//
//  NSBundle+SXDynamic.h
//  SXKit
//
//  Created by taihe-imac-ios-01 on 2021/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (SXDynamic)
- (nullable UIImage *)sx_img:(NSString *)img;
- (nullable NSString *)sx_imgPath:(NSString *)img;
@end

NS_ASSUME_NONNULL_END
