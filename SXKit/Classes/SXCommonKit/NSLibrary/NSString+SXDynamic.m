//
//  NSString+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSString+SXDynamic.h"

@implementation NSString (SXDynamic)

- (NSAttributedString *)sx_attrs:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    return [[NSAttributedString alloc] initWithString:self attributes:attrs];
}

- (BOOL)sx_isPhoneNumber {
    return self.length > 0;
}
@end
