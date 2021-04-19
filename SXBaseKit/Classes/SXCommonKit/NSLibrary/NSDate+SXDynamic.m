//
//  NSDate+SXDynamic.m
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSDate+SXDynamic.h"

@implementation NSDate (SXDynamic)

- (NSDate *)zeroDate {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDateComponents *)dateComponents {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
}

@end
