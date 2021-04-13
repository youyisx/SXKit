//
//  UIColor+SXDynamic.h
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define SXColorHex(A) [UIColor sx_colorWithHexString:A]
#define SXColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SXColorRGB(r,g,b) SXColorRGBA(r,g,b,1)
@interface UIColor (SXDynamic)

+ (UIColor *)sx_colorWithHexString:(NSString *)hexString ;

@end

NS_ASSUME_NONNULL_END
