//
//  NSString+SXDate.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/4/25.
//

#import "NSString+SXDate.h"

@implementation NSString (SXDate)

+ (NSDateFormatter *)sx_shareFormatter:(NSString *)formatter {
    static NSMutableDictionary *params = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        params = @{}.mutableCopy;
    });
    NSDateFormatter *obj = params[formatter];
    if (obj == nil) {
        obj = [[NSDateFormatter alloc] init];
        [obj setDateFormat:formatter];
        [obj setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [obj setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        params[formatter] = obj;
    }
    return obj;
}

- (NSDate *)sx_dateWithFormat:(NSString *)format {
    if (self.length == 0) return nil;
    return [[NSString sx_shareFormatter:format] dateFromString:self];
}

@end

