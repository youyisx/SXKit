//
//  UIColor+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIColor+SXDynamic.h"

@implementation UIColor (SXDynamic)

+ (UIColor *)sx_colorWithHexString:(NSString *)hexString {
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self sx_colorComponentFrom: colorString start: 0 length: 1];
            green = [self sx_colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self sx_colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self sx_colorComponentFrom: colorString start: 0 length: 1];
            red   = [self sx_colorComponentFrom: colorString start: 1 length: 1];
            green = [self sx_colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self sx_colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self sx_colorComponentFrom: colorString start: 0 length: 2];
            green = [self sx_colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self sx_colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self sx_colorComponentFrom: colorString start: 0 length: 2];
            red   = [self sx_colorComponentFrom: colorString start: 2 length: 2];
            green = [self sx_colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self sx_colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)sx_colorComponentFrom: (NSString *) string
                           start: (NSUInteger) start
                          length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
